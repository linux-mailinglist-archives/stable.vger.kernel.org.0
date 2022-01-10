Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4D248A3E4
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345636AbiAJXsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiAJXsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:48:16 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C615C061748;
        Mon, 10 Jan 2022 15:48:16 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id z20-20020a4a3054000000b002dbfaf0b568so3998478ooz.10;
        Mon, 10 Jan 2022 15:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=179GZ4SOPg22nZtHIr3qpu0ZoDZl8HF8KlTr7rx+vus=;
        b=LLK8LdnRmt0CTw+hZLzuo6JB3wVaUJw7Pfi7BG/Q/wld4EN5SG9py7Dwo/eYYNcllE
         TajT4Qpe91sLMOmjuHJQR7OhfySwsLxhsMlb+1G6zTqpgyhmMNA35H/9ETPFr6j5OdQ2
         J/I7bJef1vizkceSTJQOhVkA/bAfOnQch2jnG2+nvzqw8117U2eY9yhz23TxYXvxf/aT
         8Z6LscwA+SgsZRsDwkWnv+jqHu34icC8PEqK94PfP0L6Zpg5nShwwtLF+vZRBGS5C4YH
         r6tBj1sIbAVoA9MrkkHodlc+hpaMP84PIBLQ7PvcqTTOJkzi7ETyr19HDBY3lIieoqdU
         /yaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=179GZ4SOPg22nZtHIr3qpu0ZoDZl8HF8KlTr7rx+vus=;
        b=XgMPszM0MTPkUYoHjs/o5L76Sps0GyKs33w9jy/AcPO5QSywMcegBXIGRC2IV3QKot
         75bGI/GCLxdc7NEaw5RjZaCKnC+3+iiF6Udm6jFlWlWRbBl5zXMtwc689tmbZpJvvhVJ
         qPq1gDxd6YZ2JUO1hCBXNkRiV240c8u31mARo9BmaF2C4RpP4fqxxZdI/fMYpsHdNHlM
         SxkYS5hDW4VpJ4CAxcLlm8lPDsHmVundBUujHcyWjzs1FtVS2AlCyZEpin54wGf06ajj
         H9jWyJwdcIEZi3Rkei3a/6F5YaoRirzP9V421fwAeI+LQ83n2xOwMmrnxzGHlpaXUQxX
         iMwA==
X-Gm-Message-State: AOAM531T2z0Sz3hTnDbCHAgNK4Q6RLNY8fyM/fShykWHjuMK2tpIrVJ3
        PZrZUomqJuVgbyJy8DNxt/s=
X-Google-Smtp-Source: ABdhPJxHOkT8re/VYi1RvLmTzeZTBaApJAYF1PHfDEYGeLiSwmfFJW4MOTGsZXhYa33fnjU9mYhMfQ==
X-Received: by 2002:a05:6820:3d8:: with SMTP id s24mr1456794ooj.69.1641858495891;
        Mon, 10 Jan 2022 15:48:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k101sm1720877otk.60.2022.01.10.15.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:48:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:48:13 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/14] 4.4.299-rc1 review
Message-ID: <20220110234813.GA1633615@roeck-us.net>
References: <20220110071811.779189823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.299 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
