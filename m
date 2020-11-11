Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFECE2AE832
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 06:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgKKFkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 00:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKFkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 00:40:08 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEE7C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 21:40:08 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id d9so916643oib.3
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 21:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NDUtVAeVkvu9Gc32xI9255swYRKkk0TO9KMq0qQOaaU=;
        b=dlr8D/YmUWgv/Jf/c0R8525jdTh8nfECXhST6AI+/uG1Syl/mqBvP2XmjV2tL0GUia
         NE2lL6NPV2JThEGplv1Mv2AKXBJT89u9cjCWG1nhO+Fgek3Wc7xw1uEWwboSpTxpNVO7
         2/WYgow2Wu668HDGUgzN/w7+FwzW1RVTnCZW2RUHCto4ZEBTi3kU4N+1BR6AigJUk3Eo
         p+E9TU4l94ftxz4U/BV8Njr6rzrXZE+PcDgkIJQQOcKPYMP1+kwtg8dOmJdm6NUh4VEB
         ywy5KRP8Zw1kgH/flRfUT7+14BrXSK6b5NlYG3T9pqxCyD0tFX8rMwxkbvwjyuQq1OWF
         gTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NDUtVAeVkvu9Gc32xI9255swYRKkk0TO9KMq0qQOaaU=;
        b=pZ9Fgv8XvqWSiice3j19GMIQBRogb7gOijpOrBN0UfK8IvNE5FDU7euO7ziduVKNwY
         aFPgNwH5xo5VkUnghgTd1YYWyDWYwNhsCSAksrMePaBnKRGE0QbgX13g2wJo0EjCtmOS
         wYCXWMHyTwfE43iH6MS1I6jCEsgXXbYx4htibYecO1+VW1oTe12l1QLKSwN37IyMl6EJ
         Mpr0xN79y9fQNwc7HmbRi84NJ+MyMlLRET4ZPtTgfxzQx0iqqJ6SjGkxp/g3aWdLKDWW
         On1CrhqFs9O1D25FLPhAIWGyycRXRve2FvKMaT9dl0smVcP+t+LYOoLx9ZbdB+GWiAxT
         pErw==
X-Gm-Message-State: AOAM530/N9K09YD8nsQoInT+13iNRyGmH1PALgp6iVik0hDZx5kz3S7o
        GU5ut9IZbkWCYkcKdXB4maM7QA==
X-Google-Smtp-Source: ABdhPJxK6F7c/RWwxw7TCkgpzaMCWt/aNHqdIKETIZxMQKdxSmrzM+jPTd2O483Ga0o1zzppb+OFdA==
X-Received: by 2002:aca:90c:: with SMTP id 12mr1138942oij.15.1605073207304;
        Tue, 10 Nov 2020 21:40:07 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m3sm233355oim.36.2020.11.10.21.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 21:40:06 -0800 (PST)
Date:   Tue, 10 Nov 2020 23:40:04 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     rishabhb@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] remoteproc: sysmon: Ensure remote notification
 ordering
Message-ID: <20201111054004.GG332990@builder.lan>
References: <20201105045051.1365780-1-bjorn.andersson@linaro.org>
 <20201105045051.1365780-2-bjorn.andersson@linaro.org>
 <fb182a63172af055be473247bc783bd6@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb182a63172af055be473247bc783bd6@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 10 Nov 18:57 CST 2020, rishabhb@codeaurora.org wrote:

> On 2020-11-04 20:50, Bjorn Andersson wrote:
> > The reliance on the remoteproc's state for determining when to send
> > sysmon notifications to a remote processor is racy with regard to
> > concurrent remoteproc operations.
> > 
> > Further more the advertisement of the state of other remote processor to
> > a newly started remote processor might not only send the wrong state,
> > but might result in a stream of state changes that are out of order.
> > 
> > Address this by introducing state tracking within the sysmon instances
> > themselves and extend the locking to ensure that the notifications are
> > consistent with this state.
> > 
> > Fixes: 1f36ab3f6e3b ("remoteproc: sysmon: Inform current rproc about
> > all active rprocs")
> > Fixes: 1877f54f75ad ("remoteproc: sysmon: Add notifications for events")
> > Fixes: 1fb82ee806d1 ("remoteproc: qcom: Introduce sysmon")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > 
> > Changes since v1:
> > - Reduced the locking to be per sysmon instance
> > - Dropped unused local "rproc" variable in sysmon_notify()
> > 
> >  drivers/remoteproc/qcom_sysmon.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/remoteproc/qcom_sysmon.c
> > b/drivers/remoteproc/qcom_sysmon.c
> > index 9eb2f6bccea6..38f63c968fa8 100644
> > --- a/drivers/remoteproc/qcom_sysmon.c
> > +++ b/drivers/remoteproc/qcom_sysmon.c
> > @@ -22,6 +22,9 @@ struct qcom_sysmon {
> >  	struct rproc_subdev subdev;
> >  	struct rproc *rproc;
> > 
> > +	int state;
> > +	struct mutex state_lock;
> > +
> >  	struct list_head node;
> > 
> >  	const char *name;
> > @@ -448,7 +451,10 @@ static int sysmon_prepare(struct rproc_subdev
> > *subdev)
> >  		.ssr_event = SSCTL_SSR_EVENT_BEFORE_POWERUP
> >  	};
> > 
> > +	mutex_lock(&sysmon->state_lock);
> > +	sysmon->state = SSCTL_SSR_EVENT_BEFORE_POWERUP;
> >  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> > +	mutex_unlock(&sysmon->state_lock);
> > 
> >  	return 0;
> >  }
> > @@ -472,22 +478,25 @@ static int sysmon_start(struct rproc_subdev
> > *subdev)
> >  		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
> >  	};
> > 
> > +	mutex_lock(&sysmon->state_lock);
> > +	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
> >  	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
> > +	mutex_unlock(&sysmon->state_lock);
> > 
> > -	mutex_lock(&sysmon_lock);
> 
> We should keep the sysmon_lock to make sure sysmon_list is not modified
> at the time we are doing this operation?

Yes, that seems like a very good idea. I will review and update.

> >  	list_for_each_entry(target, &sysmon_list, node) {
> > -		if (target == sysmon ||
> > -		    target->rproc->state != RPROC_RUNNING)
> > +		if (target == sysmon)
> >  			continue;
> > 
> > +		mutex_lock(&target->state_lock);
> >  		event.subsys_name = target->name;
> > +		event.ssr_event = target->state;
> 
> Is it better to only send this event when target->state is
> "SSCTL_SSR_EVENT_AFTER_POWERUP"?

It depends on what the remote's requirements, I tested this and didn't
see any problems sending both SSCTL_SSR_EVENT_AFTER_POWERUP and
SSCTL_SSR_EVENT_AFTER_SHUTDOWN at least...
I don't know if I managed to hit a case where I sent any of the
intermediate states.

If you could provide some more input here I would appreciate it -
although I would be happy to merge the patch after fixing above locking
issue and then we can limit the events sent once we have a more detailed
answer, if that helps.

Regards,
Bjorn
