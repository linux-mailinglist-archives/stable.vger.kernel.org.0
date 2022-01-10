Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877ED48A1A9
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 22:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbiAJVRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 16:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiAJVRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 16:17:34 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798E8C06173F;
        Mon, 10 Jan 2022 13:17:34 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so19526389iol.5;
        Mon, 10 Jan 2022 13:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ddWPPw1otLBJON27NC68A271p9JwkTcpr/kcKwb5ceI=;
        b=Pg9yrUyN0vOD6zAT86sKUKI+M6cSxQHTW6fF/3VHJXY2s3aWtxy/BegHyx2q0KERR7
         a/wngwJlN/Q5G2E+ilO/wGJ1SuEviLXr40CmIOL1HROP4rMLqmtB+Pv2ce0j49i7DMCA
         NnFOMclwwzr5kQkMz1zJFGxvOVdDQj9EKDPT5Nn/dfyALHAtf9sYjXUAEXrBcDfNRYR7
         TrwwpPC4r7irSH2F2MW1NNWAGz82lNLl1W2G8MaDtl++dgReN5Z1Km1JRax8Ce4xCvw7
         VzZOLoCYh/5LfHCYPSIUK7TfOdxvpMxTZNl5SGD0BSj7R+pKKVn1hQQj6XF0j/tgz6BL
         TJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ddWPPw1otLBJON27NC68A271p9JwkTcpr/kcKwb5ceI=;
        b=4c1FDdS+xgHVdHGzPQMX+tDBdsTVMBuJz0ZzRgHYmFBwyckUWg7mb9g1XJlgKnPpz1
         uKhDKO9X7th+fmIRGNyHhgywacu6iwBD5gLYi2JAY0jGFT1GaM9A7N6kr6SS6lkkSDqs
         Rm3RSAo8A5VQVq6+cRUVEyxQqo1A+JVBc7GTFBidBqmRUfexv5RYGRkpN2hT7Z8XZrsY
         G1E0eFY39LPTGXosrukyd9QT7WjCtmD69m4I27lV8zXV2TBnMT9AGcRDDLnaYI6b7QZd
         1u04qKgKLoR6mesIfcJ3VlhdISc4hSNK8D7jP4i2GCtWP6MjEs6vsNhi6z/X0OAXEEGT
         A3zg==
X-Gm-Message-State: AOAM533w3ZM1eOAosxL4gbEYjKCCTq6y96+dW8633uZpYI9G0GtKhQb8
        qP8QWX2eWBfpOdU1jrfmsIREhY1BfTXTcAcPoVo=
X-Google-Smtp-Source: ABdhPJwfj9E7i+Lifw/WgBUJoxMQpmeiPXqoliocW2fdRGaWxO8QITudA3TV7qw5zAHzr8QB4sk0yQ==
X-Received: by 2002:a05:6638:72e:: with SMTP id j14mr919096jad.246.1641849453123;
        Mon, 10 Jan 2022 13:17:33 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id q11sm4738022ilu.57.2022.01.10.13.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 13:17:32 -0800 (PST)
Message-ID: <61dca26c.1c69fb81.47d8f.4cfe@mx.google.com>
Date:   Mon, 10 Jan 2022 13:17:32 -0800 (PST)
X-Google-Original-Date: Mon, 10 Jan 2022 21:17:31 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/72] 5.15.14-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 08:22:37 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

