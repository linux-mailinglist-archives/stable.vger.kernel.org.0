Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876DB6BB3A8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjCOMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbjCOMxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:53:13 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A324C87
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:53:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m35so2945871wms.4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678884786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dI/He3f8Pg3Ww5nNoarpbyKkcKv3nr9FCd5e/P42UHU=;
        b=RsKOYynl0U0AzTrd6bLat9VtKV//X5y83O7ss/qf7ne5DYovdKRu+a2GHZKBzFFHeV
         rPk7459e1RTmCU/zBoGiO2vkjxaUy6EtwUNESFmu+/3FOYjniGw0VQ71wxhg2m3HQBV9
         16fdlEnT5FNKIBSe9ZG1ltYfjhFT6zKbrd8OtIdNYVs8EsLdHuxd37AxqKNNEUB9gEh8
         F/DivZfTcJ7NF1Bjg2bsA+mpeFu6wWNRrbVNSraltGof5LGyKB6+jgARF24Ijd0iH3dp
         cWu5paxPDxCGwbftgny8rJDFQZ+fjrJUK7KzGhFZrkPp/QnKQwB03mT1TimmKR77MybB
         vuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678884786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dI/He3f8Pg3Ww5nNoarpbyKkcKv3nr9FCd5e/P42UHU=;
        b=ifbuBt9WfIIGKm8fUajrA7oMwzCUw7eza19zAl6zND2gHmnlt+9/D4lqUezbqRNRPF
         SS1sjMjzXO1az9ycmQRFWx5QBLSfNRR+2drPxu1svKfvYaI7CIGoDCWzakKmPT1MvZkD
         GugTknY13/GnKYVwEElY/kGI4ZiZ8hw3Uu5zTRzE77IetrC5imvdSlJ/LCwXQdQcoidh
         1OxJyfvucFQPR2P6x+llurJDDgKdj+4BmP+9c5vW8Zns3/jjoi49ShkR9I/nbWTY934R
         Ul8WynTvhtg12MEDA5osGGZy1ZT6s84ry0Q3Lt6l6lHa9y1vlshNaNAThTaNUr/mWDtf
         7MWg==
X-Gm-Message-State: AO0yUKXlNDLLq13iUAF/HCA6Q/4ADrYeoLpxbzcONuEzJAJyHAo0gEsP
        YWIG/7PUfj6TPuscxEaueWOKAg==
X-Google-Smtp-Source: AK7set/c3ktNFmiHClVZfSlbgszzyqPbBE10TANt2u0h/7SZElE0DsQ2DGr5AE5TVupS/qPdUZVc9Q==
X-Received: by 2002:a05:600c:3c89:b0:3df:eda1:439c with SMTP id bg9-20020a05600c3c8900b003dfeda1439cmr4275550wmb.11.1678884786361;
        Wed, 15 Mar 2023 05:53:06 -0700 (PDT)
Received: from airbuntu (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c234100b003e00c453447sm1718229wmq.48.2023.03.15.05.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 05:53:05 -0700 (PDT)
Date:   Wed, 15 Mar 2023 12:53:04 +0000
From:   Qais Yousef <qyousef@layalina.io>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <20230315125304.g6yuhltvewnfneqs@airbuntu>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
 <ZBGHpGccMmxHnUns@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBGHpGccMmxHnUns@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/15/23 09:53, Greg KH wrote:
> On Wed, Mar 15, 2023 at 09:03:45AM +0100, Greg KH wrote:
> > On Wed, Mar 08, 2023 at 04:22:00PM +0000, Qais Yousef wrote:
> > > Portion of the fixes were ported in 5.15 but missed some.
> > > 
> > > This ports the remainder of the fixes.
> > > 
> > > Based on 5.15.98.
> > > 
> > > Build tested on x86 with and without uclamp config enabled.
> > 
> > Now queued up, thanks.
> 
> Wait, should we also queue up a2e90611b9f4 ("sched/fair: Remove capacity
> inversion detection") to 5.10 and 5.15 now as well?

It has a dependency on e5ed0550c04c ("sched/fair: unlink misfit task from cpu
overutilized") which is nice to have but not strictly required. It improves the
search for best CPU under adverse thermal pressure to try harder. And the new
search effectively replaces the capacity inversion detection, so it is removed
afterwards.

I'd like to have it but find_energy_efficient_cpu() looks a bit different for
a straightforward backport and opted to avoid the risk.

Happy to reconsider though.


Thanks!

--
Qais Yousef
