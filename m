Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE63C463AB5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhK3P6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbhK3P6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:58:49 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA21C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 07:55:30 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s139so42030132oie.13
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 07:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=D67iPqIaGFhEeTbvB2/t/cPWQ9nJtJoiJa//C/0pMmE=;
        b=TR3TouPk91IIawco2FDGpSGuIyJqHJcFKPvYryoAGsFTa4LE59ucnWCLrHBh3yObXW
         ZTlWm3hmel6BomThKarPlqTihTqyqyKKj2O4Q/PQNVt9b8PPCvUCR6gfsAshlDRTnYvo
         w1AR9AkNo9dtkzsVeBZSIY13Wgs+jc/7SeV8juGblSDIqiSdGxgPfNnrv2aKK7b3wdhh
         cpGe3J4ZGr4Plz/b18nWCL71iRGJDfjM9T2Jsp/vPlotOGVcmJsmcecQyGSQpJluA8Go
         i1l0ALMUAN0sn7tJpEFEHo8qxEb2rzfwhqX5ZhRMmf5smB1sps9whRX3SxA1b+anSaDl
         hMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=D67iPqIaGFhEeTbvB2/t/cPWQ9nJtJoiJa//C/0pMmE=;
        b=700vuSOTJlnQZE7spaBILtsnNmtOFSStvjDV6YSgd7faoBDlEYvjyC2XxS3J1Meq1W
         PTWAlbNfn2RYQuad9W8jIKxKKe+1R5LCsA0AdKUItwtOon7zV29cG2bP8oAsBRJfpkKu
         Od07TZdAVRchC8D5lusPCQ4XZPQ++WnHT2CcVEhHGLFqzDYCigbA+5Zgk0wJpdSXMVFT
         XHKuQappLOPx/t/rGT/MGwTS2T6HtIWLTFsadpCrf+THDy+S6zxFd+9Xo48oESWy4In5
         9wrK1t3cwsGl1Nk1DxQwqTBdTTD3H/X9653rNX/b0eG3+3kHcHcTbdr2b9unopvcAZSL
         kJGg==
X-Gm-Message-State: AOAM533AoV5O5LkRUlgIATb558XWQaydhTYP8dim5X5LIHjqCMRZoBGq
        7YysSFmXelB+QZCiNZOE8ZVdxHvt1kE=
X-Google-Smtp-Source: ABdhPJwfWBeqRf1TfPQDmo26zcyfYBy2DKWW+zMyGs51ak9dY1gbS8dKCophkn4/yYpc8/coQwaGCQ==
X-Received: by 2002:a54:4595:: with SMTP id z21mr173693oib.169.1638287729653;
        Tue, 30 Nov 2021 07:55:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l24sm2803043oou.20.2021.11.30.07.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 07:55:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failure in v4.9.y.queue
Message-ID: <4b3a8f2f-a3b5-b0c4-f93a-d1de27bf1196@roeck-us.net>
Date:   Tue, 30 Nov 2021 07:55:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building sh:rts7751r2dplus_defconfig:net,rtl8139:initrd ... failed
------------
Error log:
In file included from arch/sh/mm/init.c:25:
./arch/sh/include/asm/tlb.h:118:15: error: unknown type name 'voide'
   118 | static inline voide
       |               ^~~~~
./arch/sh/include/asm/tlb.h: In function 'tlb_flush_pmd_range':
./arch/sh/include/asm/tlb.h:126:1: error: no return statement in function returning non-void [-Werror=return-type]

Guenter
