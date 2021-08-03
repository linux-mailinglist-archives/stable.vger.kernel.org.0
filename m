Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3733DEB10
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhHCKi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhHCKi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 06:38:58 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFCCC06175F;
        Tue,  3 Aug 2021 03:38:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id x17so5935210wmc.5;
        Tue, 03 Aug 2021 03:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y3Sf/19mqziYuyg73TVTxwI84Fr7QdBKK8+Wfg8/egU=;
        b=td/i9hTYhw1106SfQdK9kBcvWnSPc0OmtxVMi0Tq4HPjP4PH9USjVyq7UF3NQLRlcX
         mDdR5QrSr/Ct7f44DrEkIwbj/z4bcCkyukuCvU694ulEnN5MI8IZlQQsjrB4xzuyd7vR
         fO7iaTvJVQSJBNGBzY6yfD24MWQd071MKIJcZ6jKAMkGJssy8T6Csc1ofJit7BM+WkqF
         LhoaQSydDh18+JzvRO4iHSUGwiq9tVCWWCSEwV6C9bk6pugYT7R4l6166231ki/u46Kw
         ZxPf+0QG0Psnt935WaeNHOo8NZAuGMwuE58oVNs3KW31ti9ps4hV7i1R+PyQiRGbv+l7
         XlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y3Sf/19mqziYuyg73TVTxwI84Fr7QdBKK8+Wfg8/egU=;
        b=fOgDLxLd7UXBQaxb2gK50qR67FmD6r96PJ/2yQ0Icxb6cimONuPxtqLQcbnWfcqMpB
         YeypUiKD3TMSBXlCrHpn0ZyF/5gPzgfpt74C93Cz0rV+MCj9MRIyISwrelsm69mVYqp3
         XBKP62OqocXc07GwyzlrHTnaucPASNDM6OTM9RISDm348TcwJrsp0ZGuDbJikQ+BlQrr
         bVj6aQOqRhFwF3xjaH4XBB0gSqbB/H67YOeGGVRAjEhcNHeLtrR5ORhJ9pqdoU9XTtXB
         ZtvIZI+tSpRXrlWm+qvlR6z3tKr9i/bS2P8wDNeXmQFpRQeEpSzIIj21eMYaaXGC/996
         zrYw==
X-Gm-Message-State: AOAM5334cBnBmrZCxTspsx1v8m0avqofhDy/Q6htZxzJI2LZTEA/flAY
        3tYxKn5G38oxa83Ajl/qSXA=
X-Google-Smtp-Source: ABdhPJzLQj8zd/VsrZdU1occFxkchrEwxirhK+9nVxaMLu2TsRdV+OEWITl2CYUD52gf5UBR8Iq2aw==
X-Received: by 2002:a05:600c:3b94:: with SMTP id n20mr10455505wms.54.1627987124863;
        Tue, 03 Aug 2021 03:38:44 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id q7sm12854870wmq.33.2021.08.03.03.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 03:38:44 -0700 (PDT)
Date:   Tue, 3 Aug 2021 11:38:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <YQkcsqYu6BKlgQGF@debian>
References: <20210802134339.023067817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Aug 02, 2021 at 03:44:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
