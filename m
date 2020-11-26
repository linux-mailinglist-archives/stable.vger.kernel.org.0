Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AC12C5B86
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 19:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404527AbgKZSGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 13:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404466AbgKZSGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 13:06:00 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23651C0613D4;
        Thu, 26 Nov 2020 10:06:00 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id r2so1486018pls.3;
        Thu, 26 Nov 2020 10:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bUrNjwVhCwZsJHipJW42I/9PACEG86XLdDz5tP9a/c4=;
        b=M+nHatoa/B78dyWhvaQfTLZnSgJs+y6Zpiqk2dOzAgH0pwWOpDJIyP1HH4JASIUd4d
         kVPvvSIdiuuWhaT9BteYW4wgyctdzl2BXxTqVGZdb1KY7wo/qfNCYxyu6+uv/Kg941Bo
         e42TYhQcbZZqgCmc219xa40hVMGDIC2QWLT8Q0WqsZfb+v5ftTCV2ejMPCIQup7VP8Hr
         hjBsAwxF9dGx/F6anXMQQ4YH8LIZxxK0r/EYaZYFWweiJsyYSb2VjLO5n89qIcifm3m4
         qn8CBnkJShQNJDtWBo6KLpxT9Kkwe23nOYpAK5a9gCdiwtVerryIEUdcLlWHdZvt88gn
         mqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bUrNjwVhCwZsJHipJW42I/9PACEG86XLdDz5tP9a/c4=;
        b=M6zhFOFlZ93ObHpshV/ovh5k/EQLldru1k7TwPGW80Hr1lT31wqPbjvUfqQ12C0J7V
         3SBSZp6+3s/l4ueWWxLQC/0L81Js10aiW5imgWYLbyI06vKOPYuT1FRyyljEQZYLSyA5
         WJpFWk4Sh3sS9ER38A4NeyR0JKGcRDgVV7JehMU1RWKz6kROTTDoIjK5xXi/5/qtW9PK
         DfSNn4MRBcnGM0DDLA0H3zORpdY/hA+1R/FYnmgObt+Vk8hWz1BgxoItwvIfCEaYuVbg
         lKySPEZOVv1DqUXn5SXpJ3UpydJl4FM2XKXOUpmIkLOVRNqDJX6iiYL5UXIUQ0FwJ2hV
         tqeg==
X-Gm-Message-State: AOAM532bIJRZvWHJxtLReJ07pIzEpzfDyltdNlN119itPgxBRrhtQMhJ
        TVKrJm+UbYefYLchaqpfTemPskvrL/dlsA==
X-Google-Smtp-Source: ABdhPJwEIqjaT/Lhqup4df1cq18ZtN0cTz0GTndwUXLQBGTd+hXZEA5zjycVJo4rFF+LWa1KsHdAjw==
X-Received: by 2002:a17:902:8305:b029:da:1339:89b with SMTP id bd5-20020a1709028305b02900da1339089bmr3605867plb.43.1606413958306;
        Thu, 26 Nov 2020 10:05:58 -0800 (PST)
Received: from google.com (c-67-188-94-199.hsd1.ca.comcast.net. [67.188.94.199])
        by smtp.gmail.com with ESMTPSA id s18sm5444339pfc.5.2020.11.26.10.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 10:05:57 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 26 Nov 2020 10:05:55 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Youngmin Nam <youngmin.nam@samsung.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        namhyung@kernel.org
Subject: Re: [PATCH] tracing: Fix align of static buffer
Message-ID: <20201126180555.GB86796@google.com>
References: <20201125225654.1618966-1-minchan@kernel.org>
 <CGME20201126124101epcas2p30b7039bc8e6a9c08e35487b39dd84767@epcas2p3.samsung.com>
 <20201126130428.17826-1-youngmin.nam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126130428.17826-1-youngmin.nam@samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 10:04:28PM +0900, Youngmin Nam wrote:
> Hi Minchan,
> 
> Feel free to add my:
> 
> Tested-by: Youngmin Nam <youngmin.nam@samsung.com>

Thanks for the testing, Youngmin!
