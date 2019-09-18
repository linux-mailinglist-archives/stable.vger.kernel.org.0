Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22DEB6458
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfIRN2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:28:10 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43057 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfIRN2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:28:09 -0400
Received: by mail-pf1-f175.google.com with SMTP id a2so4469103pfo.10
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 06:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AN1B74JEBiuqSKBrqPVx87lPmMw7IFRcPvVEsrfFWO0=;
        b=JdIBNODVPlQ7yBulZi/sHStY46F7ddyaiKPfDg9wRaU/cYaW2j1s7uKJutc2Ltcgqh
         72XdzxIXLxKAYMqWPh2RpMdZ5Any3fPyxzDnkuj+sjih6yy6cWIQeUXrNqIk+INNx3m9
         xz/ViRWHbOu1eguznjdsB/qj6pVlBJx+58iOxm2kfMRaeWTYVGHAsi/7LABH0K3l/X92
         gxh685HEqgtreJqX5QXxvWFjuboGHCeuYB1ar0tqVaYck79hnc0a5qvlX0VdWDtRahYA
         kkWipnHfF3VKE1JLKaSXacoTTBVmo5njeJQiJqHF1nFf4HSnSCaPmugS3pvfrVFIqkWN
         rljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=AN1B74JEBiuqSKBrqPVx87lPmMw7IFRcPvVEsrfFWO0=;
        b=Mde5buAjUlgKCapzePOaQNmEYSb9iSzMKhpzgKIt5YzWaz6QTjTBctVZYFmEMH8/Oh
         bsryqVWQizv4IrhfudWB9YnyTOmPqw+wOBDM+0D3RckvkCVL8J9EYpQH7CdVCB2v5jyJ
         nfszaT+YIcJ8DtYUH58FsKs7eDOq9rhgsTeLp+7fadj6141g35fiDB3bNhTwFH90PIWp
         U6Y22T0ouQ0gTYW97KU4MKKTwakBaQXItWj+8fx7HIgQ12R3sG41h6S2B9j8fgsfzPo7
         maBhYjVRm0E1E1AzpBubveZF+IZ0Lr+zJhm7M/A5djpodHowtu1e5M/JSCr32c8zaEBe
         eRLA==
X-Gm-Message-State: APjAAAXMp6wGcUF1oTUvziA0E6SlccuzGx8DWnt3pvl928hQdg5aM93V
        cAexcjGmr4lmhlDdm3dAreDc4wFk
X-Google-Smtp-Source: APXvYqxFB3kcrBruENTP7Y5x7CaE5MvdvgDXoQvKTZhYpmIFF9WWyyD/wSJDS+U0P7tC8S2+2g/yQg==
X-Received: by 2002:a63:e907:: with SMTP id i7mr3949867pgh.84.1568813288681;
        Wed, 18 Sep 2019 06:28:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b16sm12555996pfb.54.2019.09.18.06.28.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 06:28:07 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply 02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous
 check in nlm_fmn_send()") to v4.4.y
Message-ID: <86e853f7-cc89-ec97-e9d0-e6abb8c5ed6f@roeck-us.net>
Date:   Wed, 18 Sep 2019 06:28:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")
fixes a build error in v4.4.y, seen when building mips:nlm_xlr_defconfig.

In file included from ../arch/mips/netlogic/common/irq.c:65:
../arch/mips/include/asm/netlogic/xlr/fmn.h: In function 'nlm_fmn_send':
../arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise comparison always evaluates to false

The patch is only needed in v4.4.y; it has already been applied
to more recent branches.

Thanks,
Guenter
