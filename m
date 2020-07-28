Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C604223025E
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 08:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgG1GIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 02:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgG1GIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 02:08:07 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56EC0619D4
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 23:08:06 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so9341629pls.4
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 23:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v4H93n5r5JaaHCincZZJ4YGqo0Cw0aIhg3WvTO7qLbA=;
        b=iEACU+jgodAOUswG7u+iQZCpSK9FvuqqcVb/9Y7eifUCb28xEnCe8L20gK6WLrjGYZ
         IBjsL/SYk9g3GMnctvQd9SDv957KlTkkNCprZaHmEDGwn2/bKs7mWw1DQFV4FQiG0slJ
         9RrbO+OyEHu5xLrOAz1QOE2x1CWja4gr+eWtjwgct+w3YMPBtcFfT51Asq9ykEnFLivR
         U/kXyk787cD4gHygZoUQ4Uj7IXG/dT1SVsNe3AzHhI+jQQQhjgUc0cavjswmfb3bBJYK
         dxNNVAFs0UljW/pwq2+AJ2hA9HAaAx46YhqoXMmMvOYgmOSVMKlLLoffi3lURdovzoBD
         Xi2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v4H93n5r5JaaHCincZZJ4YGqo0Cw0aIhg3WvTO7qLbA=;
        b=hodOiE6KkIaJyGQQT0OGk7nDyrgImm2gY/IcMRPIWv7gNvZKsQYEiS+e00IsgkNP2U
         8g7sps4PL6KYtekIjyxBtpCiTKOkynjF7SRejomSXI73TlvHbnUncAY33QtJQPFNRv/D
         zh3yZffCFINoS9SsS9/i+lR1UkIckilj+6bEy5+Pdxx77+cs0iVswcyjzDcijWL6nSV/
         ABU9RgJgAn6JNL8/c1Yh+890ymLixhHontyRHZDdg/QezRXKvf8++ia6wvuODFp5kD+i
         5ekSoSWOJXsNax1ghUoSrIgzv9R47tzmPSEqRmSx5qOXSvXMERX/+b3Ql7nIgHrkYXIt
         Imvg==
X-Gm-Message-State: AOAM533pCZ/XjmxwwDFQyBAwSY6fT4e4S8M4Drvgj7raKakjB3osQHWw
        OYqi7hN86UKYBbWUJW0uBbeeDg==
X-Google-Smtp-Source: ABdhPJyE4pUdK3j4dSXViWaGSXStD7VAB/cLjDC6rNjrup5urqzpMaqeeFgMyWSW2sljZgqjwp310A==
X-Received: by 2002:a17:90a:f192:: with SMTP id bv18mr2636648pjb.21.1595916485617;
        Mon, 27 Jul 2020 23:08:05 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id h23sm17187642pfo.166.2020.07.27.23.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 23:08:04 -0700 (PDT)
Date:   Mon, 27 Jul 2020 23:04:33 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        evgreen@chromium.org, ohad@wizery.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] remoteproc: qcom_q6v5_mss: Validate modem blob
 firmware size before load
Message-ID: <20200728060433.GC349841@builder.lan>
References: <20200722201047.12975-1-sibis@codeaurora.org>
 <20200722201047.12975-3-sibis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722201047.12975-3-sibis@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 22 Jul 13:10 PDT 2020, Sibi Sankar wrote:

> The following mem abort is observed when one of the modem blob firmware
> size exceeds the allocated mpss region. Fix this by restricting the copy
> size to segment size using request_firmware_into_buf before load.
> 
> Err Logs:
> Unable to handle kernel paging request at virtual address
> Mem abort info:
> ...
> Call trace:
>   __memcpy+0x110/0x180
>   rproc_start+0xd0/0x190
>   rproc_boot+0x404/0x550
>   state_store+0x54/0xf8
>   dev_attr_store+0x44/0x60
>   sysfs_kf_write+0x58/0x80
>   kernfs_fop_write+0x140/0x230
>   vfs_write+0xc4/0x208
>   ksys_write+0x74/0xf8
> ...
> 
> Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  drivers/remoteproc/qcom_q6v5_mss.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> index 4e72c9e30426c..f4aa61ba220dc 100644
> --- a/drivers/remoteproc/qcom_q6v5_mss.c
> +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> @@ -1174,15 +1174,14 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
>  		} else if (phdr->p_filesz) {
>  			/* Replace "xxx.xxx" with "xxx.bxx" */
>  			sprintf(fw_name + fw_name_len - 3, "b%02d", i);
> -			ret = request_firmware(&seg_fw, fw_name, qproc->dev);
> +			ret = request_firmware_into_buf(&seg_fw, fw_name, qproc->dev,
> +							ptr, phdr->p_filesz);
>  			if (ret) {
>  				dev_err(qproc->dev, "failed to load %s\n", fw_name);
>  				iounmap(ptr);
>  				goto release_firmware;
>  			}
>  
> -			memcpy(ptr, seg_fw->data, seg_fw->size);
> -
>  			release_firmware(seg_fw);
>  		}
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
