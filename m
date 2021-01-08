Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5C02EF4E4
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 16:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbhAHPdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 10:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbhAHPdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 10:33:35 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383EC061381;
        Fri,  8 Jan 2021 07:32:41 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j20so9994548otq.5;
        Fri, 08 Jan 2021 07:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PxfKbo/Ze1UYEnyLqJyQ+l1xApQcxjj0mRY/83IgHlg=;
        b=Z/tiZeGFENf8jEpMCP2cXuG3JdPh+B3mIjUt8P3RhVDPXwsSBv1ArVnySGo1i/UdFu
         zCcF0hXUJqngHpUUu9dMZLOIXOkE7/dBoZA+3OzeHiv5AbUxGVk51EfcybB3BZyYf/7S
         VGzB8vAui+KZedNE5jYLhK9yQC+UoFqss9Ivw6Y4uldwRhK0bmiAl3lwivfmBhTWNmQ3
         UpvgDRJWQFqWKN2soPvF/5AAwHaoeTTDtBeZI/JcOefwMzbSDQyGPLcna/VsFkV/Q1Lg
         d5pdCmehROCOk27gNzzTlhCh1gKR3n669w4OV6SXJk0b7XBPPx2WVYjlerOZ6IyhK/QN
         5i2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=PxfKbo/Ze1UYEnyLqJyQ+l1xApQcxjj0mRY/83IgHlg=;
        b=TlbjI/0ZpKOOp7ryFfpKJXVv7WIrMxooktchjYnO8A07sq7C2tE18A+p3F3KjhuMND
         JYMfcOr8+BoNrkxyXhJ+AhmKjXIhO9sIXTVkz34ZSzufgmPP3MwkjnzY/F/vL/03jI5w
         Dz7aypXU5pPIDopkuhsDsqDAAeV32+7Ilb1x85yInSFFd6tb5ddY7TuIA/4H6JCD9IFS
         DW6w7knxK9N4YQ56vOJMNgv2UniccuG/A8bIM9V9IHEe5VWXKNGsXahJnE5f8QUOfJOQ
         vdzydSmFbkKZHnVoTWBFm19EIkpWsAfM3tO77o900yw+HRp71bKTXshdDuaIHM7BlGbe
         kTig==
X-Gm-Message-State: AOAM532zMPnmPbKUNK3xuggLP7d02SiWz/FDMhfJnbWJLn3N+nQy20ob
        OVk+D4bhQKWrvPONJU3Pc41DBKrwnU4=
X-Google-Smtp-Source: ABdhPJzdOLIrde+HjmZZkzFt06Ucd7tRBJlrB9k6S0/i47+wuYoKjTWni0MdVlAn58yyF7p1MGMBEw==
X-Received: by 2002:a9d:7b53:: with SMTP id f19mr3002189oto.93.1610119960068;
        Fri, 08 Jan 2021 07:32:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 39sm1816229otu.6.2021.01.08.07.32.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 07:32:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 07:32:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     David Arcari <darcari@redhat.com>
Cc:     linux-hwmon@vger.kernel.org,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        Jean Delvare <jdelvare@suse.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
Message-ID: <20210108153237.GA182053@roeck-us.net>
References: <20210107144707.6927-1-darcari@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107144707.6927-1-darcari@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 09:47:07AM -0500, David Arcari wrote:
> hwmon, specifically hwmon_num_channel_attrs, expects the config
> array in the hwmon_channel_info structure to be terminated by
> a zero entry.  amd_energy does not honor this convention.  As
> result, a KASAN warning is possible.  Fix this by adding an
> additional entry and setting it to zero.
> 
> Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counters")
> 
> Signed-off-by: David Arcari <darcari@redhat.com>
> Cc: Naveen Krishna Chatradhi <nchatrad@amd.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: David Arcari <darcari@redhat.com>
> Acked-by: Naveen Krishna Chatradhi <nchatrad@amd.com>

Applied.

Thanks,
Guenter
