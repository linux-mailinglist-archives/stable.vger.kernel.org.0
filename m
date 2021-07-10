Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40B3C342B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 12:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhGJKkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhGJKkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 06:40:12 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D204C0613DD;
        Sat, 10 Jul 2021 03:37:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i94so15962204wri.4;
        Sat, 10 Jul 2021 03:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hL7SVSUAiIxR+dtLxcbW5RDKonY03J4Ra3YH0BN5oQU=;
        b=BeDVSXlwRWpMcoPYAzveA/zCOnwXmh4JOVYksppQaDUmXF+vLC6bJO2+EXVfbRp02U
         JnVbKCUBenjPDgM9bGm6OVeOwgEjUVkV9JxXGXqhPLAkjDWx6uwxPX9eSTxCRmPMDRFU
         kSheyqRxiFECEBAbkBR57NoaTU9qR0gemQaayzrOkf54ceoIefKE6W4XJ15E9gCeYHM8
         zaoLJCuw1IK2qn7EDzNDrqJifzB/ovx8mbln3ABt93soUBAHS/ZN7De2gy3Yj2DB3lea
         sw/PMVCKZ9LAX8WFShqC/WdeOnDf7eeuB4tZaZWuzvbIWchAmmgyDogYS1eRlcUiWMLl
         7p1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hL7SVSUAiIxR+dtLxcbW5RDKonY03J4Ra3YH0BN5oQU=;
        b=aqDkmpnUIlcSP2mOCZ6ijJyNjR/HFebAb1AJuVKEdGH52bctfhW5nUrZsNKRY1yx5m
         xyyjwie9DJ1U2XUF9SJbsp4A3G7VXnJ3oAo+r7EdH7AtN8A0tHIeH+TPQqLH7vYi4VRM
         arHf+B1vuzMPPTdPUL01XqQ7tUS7ZJL6GTMmJJzzI/fCdDxEuvUz8LmltdrryHtXTWc0
         gNw8ZKuA43RMbiiNxzf9kX+kkA3isXm14JHq5Z0nlRSDtRJexy7CVAVR6Pi7BYS3q6Nb
         k3WX9Hv1LniHS6sjh9ms/hI1bW2V9+8FLRLPJZz4DAr43dO6trCvDsJRnvn4RJBP5Dyu
         G1nw==
X-Gm-Message-State: AOAM531ohDtqWR55ZytRzIqvWux3XPuP+22UNv2ajP5n5Bv0gf2mO1E8
        lSgeyAehIj1iVoa0LKOnMl0=
X-Google-Smtp-Source: ABdhPJxWsZaIIcJ9D6/ReFgdhCKhUDZ1ELMxDG7cAk/c3yih299ktotPObAM0APKPjMfim4X0Wp4GA==
X-Received: by 2002:adf:c448:: with SMTP id a8mr27029939wrg.103.1625913446308;
        Sat, 10 Jul 2021 03:37:26 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id p9sm7707306wrx.59.2021.07.10.03.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 03:37:25 -0700 (PDT)
Date:   Sat, 10 Jul 2021 11:37:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/4] 5.4.131-rc1 review
Message-ID: <YOl4ZCAZi9fFAbGM@debian>
References: <20210709131531.277334979@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 09, 2021 at 03:20:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.131 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 65 configs -> no failure
arm (gcc version 11.1.1 20210702): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
