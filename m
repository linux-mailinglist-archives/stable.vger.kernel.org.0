Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1364035A797
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhDIUIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhDIUIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:08:24 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99019C061762;
        Fri,  9 Apr 2021 13:08:11 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so6867829otn.1;
        Fri, 09 Apr 2021 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FDi8twRY3pAIh9FY0xZNV+Kr720yHQSrwVhdhEFDaOM=;
        b=XSdIw5vxZ1Mc/bguKfv0EIiGdUlUHtSyIZeRUqu/4loSiPb+s56BwyNfeyCQaHEYod
         ATaNxoMZrzSI/raFfIuwId684RJLIshSdFw624Twht65VjBf5bmwFNzSIxCnoVjTweeR
         lvj9zwoe1WRQDpM4GzzZpMS1eHbFAXuy2gq6FKcTovvJUiywKss1WyfGElMylORhG23U
         uHe8m5kFdFdtH3fiGv8BKeArFpXr/TU05vjo65bO1LVJDUMreH0zIUza8hq+F9zzwA4s
         yLCMNfQFEMY2Ho4kMooQr0Rs9M07T03PJsv0C6dG8pFNhCfQz4jVsQpxXXLDPD5iiHVb
         XkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=FDi8twRY3pAIh9FY0xZNV+Kr720yHQSrwVhdhEFDaOM=;
        b=ElIKZ+YbpV2j5bnxmsGqclpt2CQso2i0QYPR6rcfoYN7mcEsCgyIbLrjs9xaU5yk1H
         DWG5G4jy8ulherf+x+ObEPTDaIjoIcaliNAAB0suk7sNkzE4iSKshiWqRzHnS2uxxzds
         uwJ+Su7YaLZQjNGhBc4+BVcG4ooo0Gkd1j3XNifRnTK3FQIxDGEOQV58QKqN7uex06s4
         hO3N+MI2OPKtc2K2gbfGhpNqI+gV3d+3RGnT7xLp6t8Kf1M2UbGKYb1gI4W0N8s94OnY
         kbk2wLBF8XuTa2WvsihG4wnmfQH6ba2erIkEZgb0EH7/trWYq82EvG+CnQVvf9xaxE2J
         GSAA==
X-Gm-Message-State: AOAM531i41t/vls0QWjvq2rVynPOEjyexQj7+Ztc21eMZaPValyCcIE2
        9CqTjECpV+3cwKKe33xbt5E=
X-Google-Smtp-Source: ABdhPJyzaLGNSmMnKwsoXwmLLDiQIjwCm/+p9XuLKkLCbe+BX1vYGH65ahQq+Ao+jgly0ikF9KXeGQ==
X-Received: by 2002:a05:6830:808:: with SMTP id r8mr14078396ots.61.1617998891063;
        Fri, 09 Apr 2021 13:08:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z17sm807820ote.77.2021.04.09.13.08.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:08:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:08:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/20] 4.4.266-rc1 review
Message-ID: <20210409200808.GA227412@roeck-us.net>
References: <20210409095259.957388690@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.266 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
