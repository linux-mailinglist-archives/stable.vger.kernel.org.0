Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE135BACBB
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiIPLtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiIPLtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:49:43 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2887B2C10E;
        Fri, 16 Sep 2022 04:49:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v185-20020a1cacc2000000b003b42e4f278cso16675249wme.5;
        Fri, 16 Sep 2022 04:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=ZNy2G5TiScnj5f0egZW9OhMmUoJRuGBqKdbzcY0u1Og=;
        b=P2V/UQQsYHRCWSwq3IueIa8FVD66HGy7WnkISZ/Fm3Uivkb76K0eq3mzLLq+rC0/Z7
         B4C3xoPWjz9Lf3a9eoFqm3U6TpN9TUKATs+UQvspNSYQbAqlh/3HgigVdsWmYq+bi9Ca
         7eusJGMJmSOmhFdZhpKk2na3gew6EWmXLJu8KYRZgcu8lu3OVuTnearr5dTQhjo1Inhl
         sUv1rWUFlq/woNLow97/SKqGrFH6+lCdntI+vPCNj6e2Vg1SPYDSyVKS2M+o79IC25aE
         OZTfGf5EQbcD3r5vely11d63k8W+5zpWBVdfElH/CkPwFaJRZEC6eoXSz6cEnqCVG2e1
         3jpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ZNy2G5TiScnj5f0egZW9OhMmUoJRuGBqKdbzcY0u1Og=;
        b=TjaE/Sugc+vDNLFEY7sH0yi4Qm2Bhz6COUSHznJh0+Gvb20Zd12JZk+SCRh2zwqi9M
         90YWt6MFzptNOMsQ9PCUp3/z2s3gvz8DVeXWwR1rY9OT6O9RsxSDWbuXcClX33oT/myx
         lx0gJYIgPFfNld/BJn47CgLN4HWaYAqIyRyVOec52pFXWF2ZRl+tHe6DRFiFonk8meHy
         D7/xgTSjUUt9uTQZ549M4NvzQe52clO8qeeD/mGJyxyIJRWAS2WOXJRdIrrT1PKpb3rk
         ULCgi03Yftk4V4Xp+BMyt2FKN7+BdbAE+WhPzgmZpDYoIPy2oPGlM45tS1oOycXoOsNK
         MlJQ==
X-Gm-Message-State: ACrzQf1T96dep0Rx+5hvlqkJ50ZKeL5O4L7F4VS+ZVcExRRctrrwwaEY
        QdZKCb7UEzcR/Zwt0EEtAugGkhflO7g=
X-Google-Smtp-Source: AMsMyM5IsJCvsYqqs4wWRuv42Uuf87f0rQivT6vUEx3MJEMF7WZdOPqtTNiglh4jXKy23mUvCrMyag==
X-Received: by 2002:a05:600c:500c:b0:3b4:92e4:c77c with SMTP id n12-20020a05600c500c00b003b492e4c77cmr3085815wmr.41.1663328979505;
        Fri, 16 Sep 2022 04:49:39 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id v26-20020adfa1da000000b00228c483128dsm5785768wrv.90.2022.09.16.04.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 04:49:38 -0700 (PDT)
Message-ID: <632462d2.df0a0220.44eb3.d76a@mx.google.com>
X-Google-Original-Message-ID: <YyP3cC6MLaqh060M@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 06:11:28 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: raw: qcom_nandc: handle error pointer from
 adm prep_slave_sg
References: <20220916001038.11147-1-ansuelsmth@gmail.com>
 <4dcb0e76-b965-42da-b637-751d2f8e1c51@www.fastmail.com>
 <632455db.df0a0220.9684.aafc@mx.google.com>
 <c243fd70-782c-4663-b08d-99f44ae55fc3@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c243fd70-782c-4663-b08d-99f44ae55fc3@www.fastmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 01:45:17PM +0200, Arnd Bergmann wrote:
> On Fri, Sep 16, 2022, at 5:11 AM, Christian Marangi wrote:
> > On Fri, Sep 16, 2022 at 11:01:11AM +0200, Arnd Bergmann wrote:
> >
> > Thanks for the review and the clarification!
> > (Also extra point the fixes tag will match the driver)
> 
> Regarding the fixes tag, how did you actually get to my patch?
> While it's possible that it caused the regression, it did not
> introduce the ERR_PTR() usage that was already there in
> 5c9f8c2dbdbe ("dmaengine: qcom: Add ADM driver").
> 
> Maybe there is another bug that needs to be addressed in this
> driver?
> 
>       Arnd

Don't know if you received the other fix, but 03de6b273805 broke
ipq806x. I already sent a fix for that but since it was added extra
check for crci, it seems logical that 03de6b273805 should have also
updated the nandc driver to handle the new pointer error. This was not
done so I added that fixes tag.

Tell me if the logic was wrong...

-- 
	Ansuel
