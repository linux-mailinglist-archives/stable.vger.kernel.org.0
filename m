Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126F84AA26D
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiBDVlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 16:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiBDVlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 16:41:24 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA16C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 13:41:23 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id m185so752150iof.10
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 13:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hf3j/B/u9j0zEVG/1z/r9PMXRInjoc1QuOtnNumsdB0=;
        b=KML9hhEdHbGC+pZsHzTAaCtxzhzWQu/OY5XmrO8/c9Lve6QjRZjzZOQT3XRuuwYSOo
         kteU9D5M5RQbubVXMgDnrwQV3cRICl8FpKbq0xqhq+pYbbYZTvUU5FJPee7F1iq0vDUq
         7FNOTwniQg8vXHcfROlblnXi3dBoh7WfB4DoNqdbMPZ0M7BXiZv3Lms3jgJdbk0mlTbW
         u0W3JiCrGfMtnnDRh/sU4HKTBhqtYv4JUYktapcBSGwUmQsY2jTXen7wk4+IjK8i6OjC
         5S/4UK+XPWEtJiKH+k9VsugktyTO7i02EUNmPymAMb9xPVwuWbDXtykzpxHQgobOYa3b
         0Kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hf3j/B/u9j0zEVG/1z/r9PMXRInjoc1QuOtnNumsdB0=;
        b=LpgVMcwjZueEQL2lYeGmU8b+sTztBW+GycdMt8lBw66bQ+kK5hqyVRhfFgomRuGLx8
         cPa0Tfv27M1fZBD+GxDBMB07wXMTsdqxZ6CAJsSreC4syCaxJ4sUNnPYrpswSyka9loL
         KcFFUpO1VcW8PvCszexQvk3juG3JEHL6bKjtPAQnFDHi6nXMwiI7ZdHew+eGuHj6OENC
         1JVi5a61MXDb2Oq8lZXTwYTZt+uZrtUr3j1fV8Ms2nwuWLPYojpZwp0H2nUAD0egyQzP
         bOY572BCO7fK54NqYI6zeaaeQij2llIAqcFgpfgQGl5KMm5pWAQyd+hqJz2lCAPx5n2/
         d3Hw==
X-Gm-Message-State: AOAM53211ohAJoYINLQdhHrM/dRa8ReOTS5I8sOg0/N6I59wGmSR8NhT
        HCyE9EDLr4slCHVSA9QZYF2S1g==
X-Google-Smtp-Source: ABdhPJx8LUYyh5vzBcTxWSs9cJKh7HdmwjoQ9TKeI18rNXahpIr1JIH99lqCjiV/dzUdYoR4y+iVLQ==
X-Received: by 2002:a05:6638:34a6:: with SMTP id t38mr580751jal.86.1644010882039;
        Fri, 04 Feb 2022 13:41:22 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d11sm1380054ioc.49.2022.02.04.13.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 13:41:21 -0800 (PST)
Message-ID: <b4a3db1e-9bee-5075-9b45-1e1dcc06869e@linaro.org>
Date:   Fri, 4 Feb 2022 15:41:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] net: ipa: request IPA register values be
 retained" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, kuba@kernel.org,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Cc:     stable@vger.kernel.org
References: <1643964634201142@kroah.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <1643964634201142@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/22 2:50 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I just tried to apply this patch on v5.15.19 and it applied
cleanly for me.

----------------

{2314} elder@presto-> git checkout -b test
Switched to a new branch 'test'
{2315} elder@presto-> git reset --hard v5.15.19
HEAD is now at 47cccb1eb2fec Linux 5.15.19
{2316} elder@presto-> git cherry-pick -x 
34a081761e4e3c35381cbfad609ebae2962fe2f8
[test 71a06f5acbb05] net: ipa: request IPA register values be retained
  Date: Tue Feb 1 09:02:05 2022 -0600
  3 files changed, 64 insertions(+)
{2317} elder@presto-> git log --oneline -2
71a06f5acbb05 (HEAD -> test) net: ipa: request IPA register values be 
retained
47cccb1eb2fec (tag: v5.15.19, stable/linux-5.15.y) Linux 5.15.19
{2318} elder@presto->

----------------

I don't understand.  If you know that I'm doing something wrong,
can you let me know what it might be?



While I have your attention on this, there is another commit
that should be back-ported with this.  It did not have the
"Fixes" tag, unfortunately.

Bjorn has committed it in the "arm64-for-5.18" branch in the
Qualcomm repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
   73419e4d2fd1b arm64: dts: qcom: add IPA qcom,qmp property

He says he has no plans to rebase this branch before it gets
pulled.

I can send a followup message when that commit lands in v5.18-rc1,
but it might be simplest to take care of it now.

What do you think?

FYI, here's the message:
   https://lore.kernel.org/lkml/20220201150738.468684-1-elder@linaro.org/

Thanks.

					-Alex


> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 34a081761e4e3c35381cbfad609ebae2962fe2f8 Mon Sep 17 00:00:00 2001
> From: Alex Elder <elder@linaro.org>
> Date: Tue, 1 Feb 2022 09:02:05 -0600
> Subject: [PATCH] net: ipa: request IPA register values be retained
> 
> In some cases, the IPA hardware needs to request the always-on
> subsystem (AOSS) to coordinate with the IPA microcontroller to
> retain IPA register values at power collapse.  This is done by
> issuing a QMP request to the AOSS microcontroller.  A similar
> request ondoes that request.
> 
> We must get and hold the "QMP" handle early, because we might get
> back EPROBE_DEFER for that.  But the actual request should be sent
> while we know the IPA clock is active, and when we know the
> microcontroller is operational.
> 
> Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
> Signed-off-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
> index b1c6c0fcb654..f2989aac47a6 100644
> --- a/drivers/net/ipa/ipa_power.c
> +++ b/drivers/net/ipa/ipa_power.c
> @@ -11,6 +11,8 @@
>   #include <linux/pm_runtime.h>
>   #include <linux/bitops.h>
>   
> +#include "linux/soc/qcom/qcom_aoss.h"
> +
>   #include "ipa.h"
>   #include "ipa_power.h"
>   #include "ipa_endpoint.h"
> @@ -64,6 +66,7 @@ enum ipa_power_flag {
>    * struct ipa_power - IPA power management information
>    * @dev:		IPA device pointer
>    * @core:		IPA core clock
> + * @qmp:		QMP handle for AOSS communication
>    * @spinlock:		Protects modem TX queue enable/disable
>    * @flags:		Boolean state flags
>    * @interconnect_count:	Number of elements in interconnect[]
> @@ -72,6 +75,7 @@ enum ipa_power_flag {
>   struct ipa_power {
>   	struct device *dev;
>   	struct clk *core;
> +	struct qmp *qmp;
>   	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
>   	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
>   	u32 interconnect_count;
> @@ -382,6 +386,47 @@ void ipa_power_modem_queue_active(struct ipa *ipa)
>   	clear_bit(IPA_POWER_FLAG_STARTED, ipa->power->flags);
>   }
>   
> +static int ipa_power_retention_init(struct ipa_power *power)
> +{
> +	struct qmp *qmp = qmp_get(power->dev);
> +
> +	if (IS_ERR(qmp)) {
> +		if (PTR_ERR(qmp) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +
> +		/* We assume any other error means it's not defined/needed */
> +		qmp = NULL;
> +	}
> +	power->qmp = qmp;
> +
> +	return 0;
> +}
> +
> +static void ipa_power_retention_exit(struct ipa_power *power)
> +{
> +	qmp_put(power->qmp);
> +	power->qmp = NULL;
> +}
> +
> +/* Control register retention on power collapse */
> +void ipa_power_retention(struct ipa *ipa, bool enable)
> +{
> +	static const char fmt[] = "{ class: bcm, res: ipa_pc, val: %c }";
> +	struct ipa_power *power = ipa->power;
> +	char buf[36];	/* Exactly enough for fmt[]; size a multiple of 4 */
> +	int ret;
> +
> +	if (!power->qmp)
> +		return;		/* Not needed on this platform */
> +
> +	(void)snprintf(buf, sizeof(buf), fmt, enable ? '1' : '0');
> +
> +	ret = qmp_send(power->qmp, buf, sizeof(buf));
> +	if (ret)
> +		dev_err(power->dev, "error %d sending QMP %sable request\n",
> +			ret, enable ? "en" : "dis");
> +}
> +
>   int ipa_power_setup(struct ipa *ipa)
>   {
>   	int ret;
> @@ -438,12 +483,18 @@ ipa_power_init(struct device *dev, const struct ipa_power_data *data)
>   	if (ret)
>   		goto err_kfree;
>   
> +	ret = ipa_power_retention_init(power);
> +	if (ret)
> +		goto err_interconnect_exit;
> +
>   	pm_runtime_set_autosuspend_delay(dev, IPA_AUTOSUSPEND_DELAY);
>   	pm_runtime_use_autosuspend(dev);
>   	pm_runtime_enable(dev);
>   
>   	return power;
>   
> +err_interconnect_exit:
> +	ipa_interconnect_exit(power);
>   err_kfree:
>   	kfree(power);
>   err_clk_put:
> @@ -460,6 +511,7 @@ void ipa_power_exit(struct ipa_power *power)
>   
>   	pm_runtime_disable(dev);
>   	pm_runtime_dont_use_autosuspend(dev);
> +	ipa_power_retention_exit(power);
>   	ipa_interconnect_exit(power);
>   	kfree(power);
>   	clk_put(clk);
> diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
> index 2151805d7fbb..6f84f057a209 100644
> --- a/drivers/net/ipa/ipa_power.h
> +++ b/drivers/net/ipa/ipa_power.h
> @@ -40,6 +40,13 @@ void ipa_power_modem_queue_wake(struct ipa *ipa);
>    */
>   void ipa_power_modem_queue_active(struct ipa *ipa);
>   
> +/**
> + * ipa_power_retention() - Control register retention on power collapse
> + * @ipa:	IPA pointer
> + * @enable:	Whether retention should be enabled or disabled
> + */
> +void ipa_power_retention(struct ipa *ipa, bool enable);
> +
>   /**
>    * ipa_power_setup() - Set up IPA power management
>    * @ipa:	IPA pointer
> diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
> index 856e55a080a7..fe11910518d9 100644
> --- a/drivers/net/ipa/ipa_uc.c
> +++ b/drivers/net/ipa/ipa_uc.c
> @@ -11,6 +11,7 @@
>   
>   #include "ipa.h"
>   #include "ipa_uc.h"
> +#include "ipa_power.h"
>   
>   /**
>    * DOC:  The IPA embedded microcontroller
> @@ -154,6 +155,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
>   	case IPA_UC_RESPONSE_INIT_COMPLETED:
>   		if (ipa->uc_powered) {
>   			ipa->uc_loaded = true;
> +			ipa_power_retention(ipa, true);
>   			pm_runtime_mark_last_busy(dev);
>   			(void)pm_runtime_put_autosuspend(dev);
>   			ipa->uc_powered = false;
> @@ -184,6 +186,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
>   
>   	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
>   	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
> +	if (ipa->uc_loaded)
> +		ipa_power_retention(ipa, false);
> +
>   	if (!ipa->uc_powered)
>   		return;
>   
> 

