Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15D76E043
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfGSEl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:41:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37218 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfGSEl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 00:41:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so14992409plr.4;
        Thu, 18 Jul 2019 21:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NEHS8k/p3RDHsc+q/bgnh4zu2SM5JS9isaHWZm17rWI=;
        b=QAdSLjINm4TmjMpM5mBixic0nAq2EBCEJnftTGdCA+P7qerpHD/EtyH8/6w1xoEY7q
         pFBscM48qyLwTJlidY5+L+IpCALn8BFoF25iuXULn4ZqZ/b0k18cvHKFfCrmwNAq6aAC
         4mbEhIjUGfNVyi6/HcaC3IfVvBzZaxP/D/zR8Ej27gR9KwNxy7FhuI/w/M2obPIhBMiu
         AFAFDvz0PH5AiOxULfKSgZckWtDZjAU4M0STcxueJMh6U7e0Q5BkOLPxpOitTWuMzkfg
         nl21ng5Eg1VDp2xL9VyCNICrwAtNgj99f8DcAA9LQz9XIwUJ5Y6x+rwF59GxrxD8gfsh
         MWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NEHS8k/p3RDHsc+q/bgnh4zu2SM5JS9isaHWZm17rWI=;
        b=qn8e8pzC21WCP1crkcxTYFVe3XCYiyJTJfMbrbJkvrZhZbdGI9tDS4W6fDFdoZMqog
         d6CfZ96UQdEEgZcXPTWsH6aHgnoJl8d/WvqXCznsVIJGId4gRzoCZidtd1ndK5mS/Cxf
         2GdTYuAgNMNHiDUzcKPOJQOdI41yWnYGOUD4N5y3ssOkN03wa/nnEesDodtasdC8jD0y
         MuisM6NVWmAjFGmsU//lA9ztcAv1z+djD4O8glMEYYsM1VlPKrxLKLMdA1c2y/l9frY6
         /vOm7FqsWCudweGaf9e14u6NATV91b9c+wHUI4+KFSCH5HjfsgNYAOam0qspefesawAQ
         z/kg==
X-Gm-Message-State: APjAAAUR5oDSmwiu/pTDEHFJ4c4I8YL/2M3SGRUPrQ3MV+zGDURqhHkt
        +KO0kX+p8M46a77xUhr6sv4=
X-Google-Smtp-Source: APXvYqxN2LEf4x8FxwNYHV1lNlbWEPs2TpBpl9j1BW2I7doXBURMUpDGC7kt8MvhIt4a/w13Dayi9w==
X-Received: by 2002:a17:902:583:: with SMTP id f3mr54233919plf.137.1563511286495;
        Thu, 18 Jul 2019 21:41:26 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id g1sm55358081pgg.27.2019.07.18.21.41.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 21:41:25 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:11:19 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/54] 4.9.186-stable review
Message-ID: <20190719044118.GB3652@bharath12345-Inspiron-5559>
References: <20190718030048.392549994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted in my x86 test machine. No regressions found.

Thank you
Bharath
