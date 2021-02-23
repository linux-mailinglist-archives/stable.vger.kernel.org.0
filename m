Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB56322C93
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhBWOli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:41:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231523AbhBWOlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614091210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yTY/vPD19Elz7ZrYsYyd2okOff2AH6M76I4vHcyMx8=;
        b=fkX2eAurUqWyg+CWDhiL69GCpGpkWi3CsxPsRoEkEJKOIQAVVHu/Nz5/+exVTSf3qWvpCR
        b0dJA/g0IF8GEATGuMidlcajBB4dDQuiE0FpJjK8t9i+3Kbc3YRs9CD0SC5Pvtonzmn/DC
        BXf7hw7LIpRQt7dFG1i+g2ko+tYlPRo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-ud-UM_hTOxeLW3odEEE-lQ-1; Tue, 23 Feb 2021 09:39:54 -0500
X-MC-Unique: ud-UM_hTOxeLW3odEEE-lQ-1
Received: by mail-qk1-f198.google.com with SMTP id i11so11754260qkn.21
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 06:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6yTY/vPD19Elz7ZrYsYyd2okOff2AH6M76I4vHcyMx8=;
        b=VG5b3sCxuPhKtGkahoiX+teZVk8D50yxwnV/XvNd5h8LVrc1mTQB2Ng35mRugp61/r
         Sw+zqktZ1oRUlWwTzxQ6qQLRPwTz5nrpvh/Zq4E8AX88HPBkHG7n1mkMuDt5Q+/F+7Jt
         qGk74i2sVFRnQnW+F9Xr72T+AdC9c8cb5upC7duHPx+sDbm8qUgSYV/FBKKkPtVCRK3g
         Po4TkIRLsb7j5uYffpe+RBp6TW1FNNHQ4j6xbbYGyh3DEGLOl7DbVirNLF/AWGvB2kkk
         x0ArfaoKsRcFpzmq2de/Vf3+ZBqw2o9e23fS6w5+tln19EkKc0vayuIXavWLJ+Y4KvJI
         viHA==
X-Gm-Message-State: AOAM533bTcuHg+9O8nRiO8T4DGQYcrk+XtU+FIOzdKAJwga0XQt545ZI
        TB7Ix6D2oXSgZ6A3ObRdYR31FecIkla/7nh/CYU6gjVPPLVytora8Zoxu2szWuHuXnlO+WeoZUU
        czGofoeLJrhyORxqn/+LNPLGGI0AW5BsJHj/6aT2ZBX0+MjSL9ze+3VX/zR9yuOY=
X-Received: by 2002:ac8:70ce:: with SMTP id g14mr4859057qtp.297.1614091193757;
        Tue, 23 Feb 2021 06:39:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv8bN6MNquo1jGL/fVslpXBJQiYoUqw9O5hOq8jrxc3Ssv2oGxE+KGcHa7ABf9JSxsK9FNyw==
X-Received: by 2002:ac8:70ce:: with SMTP id g14mr4859020qtp.297.1614091193399;
        Tue, 23 Feb 2021 06:39:53 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id d17sm15161843qkc.40.2021.02.23.06.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 06:39:53 -0800 (PST)
Subject: Re: [PATCHv3] firmware: stratix10-svc: reset
 COMMAND_RECONFIG_FLAG_PARTIAL to 0
To:     richard.gong@linux.intel.com, gregkh@linuxfoundation.org,
        "mdf@kernel.org" <mdf@kernel.org>, Wu Hao <hao.wu@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Richard Gong <richard.gong@intel.com>,
        "# 5 . 9+" <stable@vger.kernel.org>
References: <1614089759-12658-1-git-send-email-richard.gong@linux.intel.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <0993ec07-1424-256a-512d-3455c7a5db41@redhat.com>
Date:   Tue, 23 Feb 2021 06:39:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614089759-12658-1-git-send-email-richard.gong@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Richard,

I see this is for stable.

Your mainline patchset looks ok with me, has it been accepted yet for mainline ?

Reviewed-by: Tom Rix <trix@redhat.com>


On 2/23/21 6:15 AM, richard.gong@linux.intel.com wrote:
> From: Richard Gong <richard.gong@intel.com>
>
> Clean up COMMAND_RECONFIG_FLAG_PARTIAL flag by resetting it to 0, which
> aligns with the firmware settings.
>
> Cc: <stable@vger.kernel.org> # 5.9+
> Fixes: 36847f9e3e56 ("firmware: stratix10-svc: correct reconfig flag and timeout values")
> Signed-off-by: Richard Gong <richard.gong@intel.com>
> ---
> v3: correct the missing item in the Fixes subject line
> v2: add tag Cc: <stable@vger.kernel.org> # 5.9+
>     add 'Fixes: ... ' line in the comment
> ---
>  include/linux/firmware/intel/stratix10-svc-client.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/include/linux/firmware/intel/stratix10-svc-client.h
> index a93d859..f843c6a 100644
> --- a/include/linux/firmware/intel/stratix10-svc-client.h
> +++ b/include/linux/firmware/intel/stratix10-svc-client.h
> @@ -56,7 +56,7 @@
>   * COMMAND_RECONFIG_FLAG_PARTIAL:
>   * Set to FPGA configuration type (full or partial).
>   */
> -#define COMMAND_RECONFIG_FLAG_PARTIAL	1
> +#define COMMAND_RECONFIG_FLAG_PARTIAL	0
>  
>  /**
>   * Timeout settings for service clients:

