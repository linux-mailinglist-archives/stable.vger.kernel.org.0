Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7297F1AB025
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411506AbgDOR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 13:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441087AbgDORz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 13:55:58 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E725C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:55:58 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z26so4635994ljz.11
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 10:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnna/6OnfA+ZY6dFpwQADy6VF1hPNJpTLuPWcjrS+9o=;
        b=lT/jtIdHqRmRii6Mhp0kxfUeDNI5rGqofv9QErcLovXn4eP3jZocb3Bpl2WPwsG8BE
         KS3mM5EpSs+Uu+Tf56iJssZM4HvTeyjXO2moUDIzsOf3sraCA477lBpkK08LxtZKFHuR
         M6ScyxD+ddeekgfX79R9iCS71aGqv658euPY0EYzrWu4mk1S98xVzeYIyffvlQ1RCd39
         NEcluG9VClepTW+ECpxn/bGQQUo0oE2EWe9hncZ2MkRMOR/fVeT+5thwm9CPeJ+mIV2w
         XfcJFIzjYpuM0ZVVd+xatRdOe8sG3Vj/ANuev2T5NAzhy0SJwiNCNHeEHiRKGctan+R+
         DFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnna/6OnfA+ZY6dFpwQADy6VF1hPNJpTLuPWcjrS+9o=;
        b=l46+INTNiyiPVM0dGwChQW02gq6duQaKq+rAbpw68OZ5S+OE3M35IqJuFrwcXlsWGi
         5dp+k1NNppTN0dt/vqukUa1HCh9zCE+hSmhUgnLGsE0dRO99N7vx+/xRRp2AoA/P+QYr
         oZtKNHlRXDqGy+TJFZSZCAwrmTgALFfqvgCtxvlM+bBQqr2whjVxzbM4X+Xh5G6QM5Xd
         ub7VVjno6pb3vFsxZEe0HZGoqUWkBylCH8s09iTvbipH3HG0pEzouc33rnifki982ZbZ
         r1mTjS9Sh/1PhEmT13Pd32RrdFfRI0ObULArRrHIWsT9VR1mqjldxzRHtWdIU9gEA4vy
         m9xw==
X-Gm-Message-State: AGi0PuaoqJzENU81vzRUX4KIrJTao7GbSQkKoUmXpQekeYg5ZpitJZsX
        mosBGiQdEEac6AlTIMx5s/hCr4h8a8eBXRL26HHSTA==
X-Google-Smtp-Source: APiQypIAX9TwClluLsNWlpVGtTbHrq5zHPu1eJSAJi8mSv7889eeJU3EbUg3C4LKaPOzQf5ye9c0nsPcuwjNkmygnO4=
X-Received: by 2002:a2e:6c05:: with SMTP id h5mr3968173ljc.217.1586973356820;
 Wed, 15 Apr 2020 10:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com>
In-Reply-To: <1583886030-11339-1-git-send-email-skomatineni@nvidia.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Apr 2020 23:25:45 +0530
Message-ID: <CA+G9fYvreAv5HmZg0O4VvLvf_PYSvzD1rp08XONNQGExctgQ0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sdhci: tegra: Implement Tegra specific set_timeout callback
To:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, baolin.wang@linaro.org,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bradleybolen@gmail.com,
        thierry.reding@gmail.com, Jon Hunter <jonathanh@nvidia.com>,
        anrao@nvidia.com, linux-tegra <linux-tegra@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Mar 2020 at 06:41, Sowjanya Komatineni
<skomatineni@nvidia.com> wrote:
>
> Tegra host supports HW busy detection and timeouts based on the
> count programmed in SDHCI_TIMEOUT_CONTROL register and max busy
> timeout it supports is 11s in finite busy wait mode.
>
> Some operations like SLEEP_AWAKE, ERASE and flush cache through
> SWITCH commands take longer than 11s and Tegra host supports
> infinite HW busy wait mode where HW waits forever till the card
> is busy without HW timeout.
>
> This patch implements Tegra specific set_timeout sdhci_ops to allow
> switching between finite and infinite HW busy detection wait modes
> based on the device command expected operation time.
>
> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> ---
>  drivers/mmc/host/sdhci-tegra.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index a25c3a4..fa8f6a4 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -45,6 +45,7 @@
>  #define SDHCI_TEGRA_CAP_OVERRIDES_DQS_TRIM_SHIFT       8
>
>  #define SDHCI_TEGRA_VENDOR_MISC_CTRL                   0x120
> +#define SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT            BIT(0)
>  #define SDHCI_MISC_CTRL_ENABLE_SDR104                  0x8

>  #define SDHCI_MISC_CTRL_ENABLE_SDR50                   0x10
>  #define SDHCI_MISC_CTRL_ENABLE_SDHCI_SPEC_300          0x20
> @@ -1227,6 +1228,34 @@ static u32 sdhci_tegra_cqhci_irq(struct sdhci_host *host, u32 intmask)
>         return 0;
>  }
>
> +static void tegra_sdhci_set_timeout(struct sdhci_host *host,
> +                                   struct mmc_command *cmd)
> +{
> +       u32 val;
> +
> +       /*
> +        * HW busy detection timeout is based on programmed data timeout
> +        * counter and maximum supported timeout is 11s which may not be
> +        * enough for long operations like cache flush, sleep awake, erase.
> +        *
> +        * ERASE_TIMEOUT_LIMIT bit of VENDOR_MISC_CTRL register allows
> +        * host controller to wait for busy state until the card is busy
> +        * without HW timeout.
> +        *
> +        * So, use infinite busy wait mode for operations that may take
> +        * more than maximum HW busy timeout of 11s otherwise use finite
> +        * busy wait mode.
> +        */
> +       val = sdhci_readl(host, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> +       if (cmd && cmd->busy_timeout >= 11 * HZ)
> +               val |= SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> +       else
> +               val &= ~SDHCI_MISC_CTRL_ERASE_TIMEOUT_LIMIT;
> +       sdhci_writel(host, val, SDHCI_TEGRA_VENDOR_MISC_CTRL);
> +
> +       __sdhci_set_timeout(host, cmd);

kernel build on arm and arm64 architecture failed on stable-rc 4.19
(arm), 5.4 (arm64) and 5.5 (arm64)

drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
drivers/mmc/host/sdhci-tegra.c:1256:2: error: implicit declaration of
function '__sdhci_set_timeout'; did you mean
'tegra_sdhci_set_timeout'? [-Werror=implicit-function-declaration]
  __sdhci_set_timeout(host, cmd);
  ^~~~~~~~~~~~~~~~~~~
  tegra_sdhci_set_timeout

Full build log,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/83/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/158/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/511/consoleText

- Naresh
