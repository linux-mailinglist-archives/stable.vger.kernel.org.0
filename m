Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9D14CCB3
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2On7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:43:59 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33837 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA2On7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 09:43:59 -0500
Received: by mail-yb1-f193.google.com with SMTP id w17so8789396ybm.1;
        Wed, 29 Jan 2020 06:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wKswmljTOiEW0VVv8djG8gNyyeh29y7K32emEYsaq9Q=;
        b=qwPLYGOuOyyG5OVF7dSSi9zlqdxFiz8vhCcs1RTpTVAodHr9a6QqXVRC5FQ/w6vZk3
         qBOjiES0CG88FItQh/d5EoIWnUFo1X+KT/tss/DLQo7ty/JsL/lyy0NxkrT/5Zo9CG/P
         E6NqLzEJVSZMhneOwrOqVIYhRWhnZBdaPa3otrfiA7Ra6HIdgVgFGrynvTVTtavcEjk9
         6Xegn1LVVRvcDTqFQyj8mSxejBUXhawmpmiLjW8SRuKVttUAZKh8F4r79UP7na6Zhc3w
         uUYicmDMbC2ONiF3FqofQpfvi0yY0+gYFRVTuvetZ2yUNyZy0EYCqNAzdQaF4MyLjPei
         7cSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=wKswmljTOiEW0VVv8djG8gNyyeh29y7K32emEYsaq9Q=;
        b=Yvjw/Czj3zoQLTrZwmvZr/PVtTKKvOXIDnN+rXq423uMgmnll5op8MY290lnGji9pQ
         8czGDQMCGrKTauuFpKnNiOyXv2eY1tuPkOtrpI3HyBELTNHOdsaRrLdGKn/hADfbSFhH
         rBEkqGKaxs3uo4lqzYvSheXO0ocRw94tBoemdFmwuCE66o9lJ0ve+oTaL6bBeJZCaACE
         C6Oj0TspcnlMni0MGgzxuHW1fLmWfOmrb0/8+1DnDqyxWVHoRy6sKZbmDY3SwU4Az37W
         VbuV96aRGbu5PoMN9Z4zUxfGN7ZmU06qyZNpjdrDPSXMaytiUJTrxDFBaTDvAxb45Ecf
         SRNA==
X-Gm-Message-State: APjAAAV3cTfNtlLoxP4LS3UTL4WGC40duWF7fWyXMmV+fkptlXBR53y4
        7e96cWnJlY3/HQcqNwrUd5c=
X-Google-Smtp-Source: APXvYqw/Yybgc78szjVTT3dTVme2vD6QlBAeYCBvyJq6LOy9arFuyrP2CBI3KoG8en0bB6L336ocPQ==
X-Received: by 2002:a5b:f01:: with SMTP id x1mr22139793ybr.313.1580309037871;
        Wed, 29 Jan 2020 06:43:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m62sm991975ywb.107.2020.01.29.06.43.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jan 2020 06:43:57 -0800 (PST)
Date:   Wed, 29 Jan 2020 06:43:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
Message-ID: <20200129144356.GC23179@roeck-us.net>
References: <20200128135817.238524998@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 02:59:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.16 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 388 pass: 388 fail: 0

Guenter
