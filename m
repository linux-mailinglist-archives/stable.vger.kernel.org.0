Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FC56AC203
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCFN6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCFN6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:58:01 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEE444BF
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:57:55 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bx12so8876475wrb.11
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 05:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678111074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1EoLUuBr64ri9Y94yjd26dmmu4IbZltPwpImALUreU=;
        b=PeOw80iYd9tp/JQfc6pX1uwoERV/YGNa6GxEY9RMum5+mpx348WzhUfKezkq9P3g7X
         Mqs57h8I+f2F5Rrql2OpV+CDlkD27qFqfNpHQH/tHEPIswZ5UetMmypq0zGc8o2ioHYC
         gEGXy2Gkj8tJCrJVQFv17yI+DetRocDl7vxh0nFE0VLBd8DS7B4jtsc/rAOgHEN4J6qA
         XwPZiQTbSyCfGNpMsp/IAS76fnZdS/hRhPiq/vrkgwUdBdNp8DdzCVRAfH0St/iDoD42
         KKkPN4N2qe1mHeIp2LFMqPTZa94icaH9Gveim0LmCj1Aj7zqq24S3iyCqDzSiklWLcTJ
         p3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1EoLUuBr64ri9Y94yjd26dmmu4IbZltPwpImALUreU=;
        b=mCiDycxvkafi2R6AXNPVA3MDh7BYqdON2gRMmNEl8aabPHos/oL/zRTcYVTVtjuvmW
         031rUa/YCE86EGAgmitzwdzlGE5UcDcDOvfv/FxWAau1mCQnzZySyqACLRmWYC+i5i8Z
         6AUGCrvDEvK7zvBWkAKZPIhB9bE8NcOOEuhneHN6+ICf4eqwe1wBMhanLQ/Zlb1bTRCd
         kP0PhZoVrABfDOG/kT2IMLIE2CDx8X6I5d2NWjf+0ukOYM8PhNhMUEVqjFpm4mlvqBjC
         nq0nceI0jzNJrx2opEUsCgwOGatwEPOBq8HmlDcnpG7Le4+CG4QJBdLbdbfT3j3yz7/d
         M6Yw==
X-Gm-Message-State: AO0yUKUhh63AgbPtgRlDdpmi4OY2gmofXwPu7aP02pQ+mtwV9IDNMWbL
        6GP8285Zua4giME4F/RjKnCp15OpjMQbXRAoQRA=
X-Google-Smtp-Source: AK7set/ThLdaGeyDxzUSTUcgVYoCng2a28njZtarQGUr197RpgLQFxyiGrv7EXzG2Np+FD1wrIGwrQ==
X-Received: by 2002:a5d:4563:0:b0:2cd:8a2e:14e with SMTP id a3-20020a5d4563000000b002cd8a2e014emr7980239wrc.34.1678111073807;
        Mon, 06 Mar 2023 05:57:53 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id f2-20020adfdb42000000b002c54fb024b2sm9822092wrj.61.2023.03.06.05.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:57:53 -0800 (PST)
Date:   Mon, 6 Mar 2023 15:57:52 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] soc: qcom: llcc: Fix slice configuration values for
 SC8280XP
Message-ID: <ZAXxYPZ/zarxcsNF@linaro.org>
References: <20230219165701.2557446-1-abel.vesa@linaro.org>
 <ZAXkIHOom26DlVx0@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAXkIHOom26DlVx0@hovoldconsulting.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-03-06 14:01:20, Johan Hovold wrote:
> On Sun, Feb 19, 2023 at 06:57:01PM +0200, Abel Vesa wrote:
> > The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
> > LLCC config registers. Fix that by using the slice ID values taken from
> > the latest LLCC SC table.
> 
> This still doesn't really explain what the impact of this bug is (e.g.
> for people doing backports), but I guess this will do.
> 

Sent a v4 here:
https://lore.kernel.org/all/20230306135527.509796-1-abel.vesa@linaro.org/

> > Fixes: ec69dfbdc426 ("soc: qcom: llcc: Add sc8180x and sc8280xp configurations")
> > Cc: stable@vger.kernel.org	# 5.19+
> > Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> > Tested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
> > Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
> > Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> Reviewed-by: Johan Hovold <johan+linaro@kernel.org>

Added your R-b tag.

Thanks.

> 
> > ---
> > 
> > The v2 is here:
> > https://lore.kernel.org/all/20230127144724.1292580-1-abel.vesa@linaro.org/
> > 
> > Changes since v2:
> >  * specifically mentioned the 3 slice IDs that are being fixed and
> >    what is happening without this patch
> >  * added stabke Cc line
> >  * added Juerg's T-b tag
> >  * added Sai's R-b tag
> >  * added Konrad's A-b tag
> > 
> > Changes since v1:
> >  * dropped the LLCC_GPU and LLCC_WRCACHE max_cap changes
> >  * took the new values from documentatio this time rather than
> >    downstream kernel
> > 
> >  drivers/soc/qcom/llcc-qcom.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> > index 23ce2f78c4ed..26efe12012a0 100644
> > --- a/drivers/soc/qcom/llcc-qcom.c
> > +++ b/drivers/soc/qcom/llcc-qcom.c
> > @@ -191,9 +191,9 @@ static const struct llcc_slice_config sc8280xp_data[] = {
> >  	{ LLCC_CVP,      28, 512,  3, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> >  	{ LLCC_APTCM,    30, 1024, 3, 1, 0x0,   0x1, 1, 0, 0, 1, 0, 0 },
> >  	{ LLCC_WRCACHE,  31, 1024, 1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
> > -	{ LLCC_CVPFW,    32, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> > -	{ LLCC_CPUSS1,   33, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> > -	{ LLCC_CPUHWT,   36, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
> > +	{ LLCC_CVPFW,    17, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> > +	{ LLCC_CPUSS1,   3, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
> > +	{ LLCC_CPUHWT,   5, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
> >  };
> >  
> >  static const struct llcc_slice_config sdm845_data[] =  {
