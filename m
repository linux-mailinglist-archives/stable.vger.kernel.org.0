Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18EA209899
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 04:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389337AbgFYCq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 22:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYCq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 22:46:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083B3C061573;
        Wed, 24 Jun 2020 19:46:57 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x18so4823672lji.1;
        Wed, 24 Jun 2020 19:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pvycOAanKOGThnweOmUgasjLKw1f5vsz8MNnX8op5Qc=;
        b=FTUzwFz4w2QZtcYVnOQfG0K5S67ZiJnshkOGFjTtAu9JdOUZ5OOH3R/JKU9H7ST2Cr
         QVoVHN1/O2D+0o4asP4htRrQpTeudbSc/ky6kY+rdpXv93/D8x97aE8P1XUQrM0MrxDJ
         /yOjkUgkvEcBOLItY9hEeTOYVkMOG+bu1lBSfpP/XhQPHr0YIscqufbiy2G7sH2z96Np
         it53iq9BnDn3qqV+uAIs+6sJ/Ish6N2NMfEO4RM3UXOiYrJ3jVfbgtdQROC9dY94uSr8
         CZHKm6GEQG2W1MOM8wWzcA/4o8SHwdp/xjV/1IaG8TDSyS8GchsKdOnABCPEjzAqNW/t
         pwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pvycOAanKOGThnweOmUgasjLKw1f5vsz8MNnX8op5Qc=;
        b=Z1fivEdiUY0Dwi7CLMVwqUAggmGtueiKKMoxFazajqBKlnXbMphEdyOS2lCimCOQvw
         CSdM9/0RG2dxk0pqJYC6/bX7Mz2i1ZdovQe37cam6Wrl2Es1w9bvliiAilL6WYQ/qC9i
         6gd4/3pEivXL7affeojer0pgv7tBKAqgKDE8uHpVhPNgQAeGtFp6wycBx2gagwXBA+cW
         cp4e8yIJdw0aX7M/71DIeOnvx7JDOPDLfKNIWPSnnGoB/JxzbUwKGl83h2p+rRS6TbpZ
         ij9hmIsHpO+lxQnFeA4JvqjFLWYJd5JoeRZqzqpLrljTYtOmlFHz0W9kgpoQdHIOCs0R
         mQhw==
X-Gm-Message-State: AOAM530Y0gCg/DVT7Uijy1XsHJl7eBzoe2sJzQODROt23d05Q7CvUOqI
        Ia4L4lkh6Z9sQCm8MnPFGT6WNNBY+ON/vYPNVLc=
X-Google-Smtp-Source: ABdhPJzd3WDIitpGtJmw4BW9WQdwclBgOqu1H6qHgZ4TZfpJ6I3zCsUpErL7D9gIjdZUd+eKwHrtxXgT0cjqPe6NNfo=
X-Received: by 2002:a2e:82c8:: with SMTP id n8mr4510152ljh.123.1593053215553;
 Wed, 24 Jun 2020 19:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200624150704.2729736-1-lee.jones@linaro.org> <20200624150704.2729736-6-lee.jones@linaro.org>
In-Reply-To: <20200624150704.2729736-6-lee.jones@linaro.org>
From:   Baolin Wang <baolin.wang7@gmail.com>
Date:   Thu, 25 Jun 2020 10:46:37 +0800
Message-ID: <CADBw62pJZbHXwbKc36qJ=dATHyZDU=yw6Z+krWi47AJmotqEvA@mail.gmail.com>
Subject: Re: [PATCH 05/10] mfd: sprd-sc27xx-spi: Fix symbol
 'sprd_pmic_detect_charger_type' was not declared warning
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Orson Zhai <orsonzhai@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lee,

On Wed, Jun 24, 2020 at 11:07 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Sparse reports:
>
>  drivers/mfd/sprd-sc27xx-spi.c:59:23: warning: symbol 'sprd_pmic_detect_charger_type' was not declared. Should it be static?
>
> ... due to a missing header file.
>
> Cc: <stable@vger.kernel.org>
> Cc: Orson Zhai <orsonzhai@gmail.com>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Chunyan Zhang <zhang.lyra@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Thanks.
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>

> ---
>  drivers/mfd/sprd-sc27xx-spi.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mfd/sprd-sc27xx-spi.c b/drivers/mfd/sprd-sc27xx-spi.c
> index 33336cde47243..c305e941e435c 100644
> --- a/drivers/mfd/sprd-sc27xx-spi.c
> +++ b/drivers/mfd/sprd-sc27xx-spi.c
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/mfd/core.h>
> +#include <linux/mfd/sc27xx-pmic.h>
>  #include <linux/of_device.h>
>  #include <linux/regmap.h>
>  #include <linux/spi/spi.h>
> --
> 2.25.1
>


-- 
Baolin Wang
