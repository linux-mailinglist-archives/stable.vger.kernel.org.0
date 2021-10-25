Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEE543A7F8
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhJYXIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 19:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbhJYXIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 19:08:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE797C061745;
        Mon, 25 Oct 2021 16:06:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l186so5739594pge.7;
        Mon, 25 Oct 2021 16:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Ngur52vg7le9KRvczk5/psRZTKMdl8rWkzVC3BsUces=;
        b=bQXrA0XFz+8io8NpFWSmkS/qNCDktHdZEU2oAtP8kUGOYkXgAQ2nW+HoLIgsTzDCab
         r9MEnqKSKPLyQeDc07ytH5fCPwq2YBlkyVgAVGZU3KGQ5UP3y6+BkYUm8fbTVKtFTOKA
         jGEQBR0RWkG0ZrHUSTEll2LWTijtIpEfgzfASjIp84e2It6LqR3VgK0wZqLQorUHEHW3
         CyoIvMlFOCY7PN4/lhWl3dLHXpla5GCGTlFXpsOl5fKzbT5koZXQCsRedDKn2kQk0Rwa
         aoc4qFjJ1EOxlNSDKTU1SjOn6wmejVsh2h6XtTqNrZn/Hl5Ktp7PIt6WElNXl5p0sdIG
         NfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Ngur52vg7le9KRvczk5/psRZTKMdl8rWkzVC3BsUces=;
        b=SXqWgbtp9FU6z7LdKWoP6bwxTca/j24+YMRgDUG3NRE13r5gl0XU5yhgs4uGApZA5k
         KJzM2yydHdjJQJIQCuUHglYYwiQHqvlnEan9tBKSbZ0qk1xE6KsI23NuwAIbUZXymI33
         RXWA5OKMdPTjWUXzHVpKmVPwCej1W9+QoLz1Et8AjoUpa30yZ6YALbB2FnD2ohqOM9to
         0rxwAsIr3I5zckC0u+FgK4+A0XEHVPLG6qYZ5V+S3LYdfJ6n+sWq53VZo37pa6992qxG
         Fes/fCsXLFqGcY8HzmsLjnMXf/m48S74/I+th6q+eVXFXbs7wf+I0wx5kDgjIB7P/QVl
         KxEw==
X-Gm-Message-State: AOAM532lBPGQfvNFHKr7w5lh4eZDeVUVPMtKCx5IH9ZMGcWjIC5mtiDc
        dN4melpXxc9FRbcwTLNibh6nEiB9Ydj6LJZYeTA=
X-Google-Smtp-Source: ABdhPJxskO/c26xs/AfTlO03drP6mxWy3oeU1wk3aWSPC4s5eYvvSwZK479zdgz74SuiTuKDtwUWTg==
X-Received: by 2002:a62:e901:0:b0:47b:f1bc:55e4 with SMTP id j1-20020a62e901000000b0047bf1bc55e4mr8498524pfh.0.1635203183643;
        Mon, 25 Oct 2021 16:06:23 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c8sm6802301pgh.40.2021.10.25.16.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 16:06:23 -0700 (PDT)
Message-ID: <6177386f.1c69fb81.b404a.1255@mx.google.com>
Date:   Mon, 25 Oct 2021 16:06:23 -0700 (PDT)
X-Google-Original-Date: Mon, 25 Oct 2021 23:06:22 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/169] 5.14.15-rc1 review
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

On Mon, 25 Oct 2021 21:13:01 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.15 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:08:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.15-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

