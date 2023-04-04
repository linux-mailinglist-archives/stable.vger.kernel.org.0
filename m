Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E16D64C4
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjDDOH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 10:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbjDDOH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 10:07:26 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEA75258;
        Tue,  4 Apr 2023 07:06:54 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id cn12so28255628qtb.8;
        Tue, 04 Apr 2023 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680617212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqA0aoKLpeVA32vIaHb9r/e2K6aw/oZkyeQELAebYPc=;
        b=g3xNksrvYH2oPXKSdaktqR4E3st4g35PSLatf6tbVsOsXsDr1Sj1jLwbq1uBmULmIE
         2bYTxUlI4/FlwuQOYE0GnEbxfUgPo0QQrM+tJctxP1xmdn9uW0jo5wEYy/xCngbBjmBp
         B9jK6IABFElULF/1P5AZMjQ3RQqhR4a44SVLlnWCkQ62zdFGSCGbVgpB3BwEObhudPD6
         0LEpddJETCcqlK4wCGZfMkCah4Srx4ZTc4FYPqpuZ892nFiO2UFl7FQYRXr8OzNlNlIJ
         yAmvVNcKNJ23zojs+Lz5iHwJpJeeNnxjRRJqhIt6+eduGyx5D/r1Pkd3ok5Y7PebCij7
         Y2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680617212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqA0aoKLpeVA32vIaHb9r/e2K6aw/oZkyeQELAebYPc=;
        b=Ycwgll4X05++FudvdIktPbWKLoavgCSmZqP7p6859tfItrIKHVqm9ViXaJrJNiAq55
         DY/w0I2mLTCJXOZkh9LW+Y+VBdqWLrn+QeENtd04crIdJaw5TrvmP1EC47LngSDZWTT9
         3GtDgdeD2nXN9IBoKFLohx4Jws37zCPG51kuby3TugOncs9h1QlZi853DigYAkOFyk1M
         kPnUZuulADbjz/OfeBcz+F8HDpuqIm47CHbrfc3PHJJX+CY1ZZVMiJ3GWBVbtVgjEFj3
         as5c2EYFgp65/3cskLIMYyFP+4od7bsBZ0foXu5yOQUvDYkNtgzFNjM/CP3e3tre/awN
         zsTA==
X-Gm-Message-State: AAQBX9fSck+YGIJFHErmVqAo2rS73LmREqAxpmAZv64PneSZYLGED1sD
        ixifssQ88Lwe+FjEsq6Qe3w=
X-Google-Smtp-Source: AKy350aH2P68cMEab0T2UXtKUu4U0+HrVNWU2CbCXEjLk+vTfFkCPJ/GrvWomK4of+TgUI297Qjb6A==
X-Received: by 2002:a05:622a:1313:b0:3d2:7f3b:c691 with SMTP id v19-20020a05622a131300b003d27f3bc691mr3470798qtk.47.1680617211741;
        Tue, 04 Apr 2023 07:06:51 -0700 (PDT)
Received: from PCBABN.skidata.net ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id l22-20020ac848d6000000b003bfb0ea8094sm3230398qtr.83.2023.04.04.07.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:06:51 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
To:     peterz@infradead.org
Cc:     bbara93@gmail.com, benjamin.bara@skidata.com,
        dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        lee@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        rafael.j.wysocki@intel.com, richard.leitner@linux.dev,
        stable@vger.kernel.org, treding@nvidia.com, wsa@kernel.org
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
Date:   Tue,  4 Apr 2023 16:06:42 +0200
Message-Id: <20230404140642.550919-1-bbara93@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404082255.GU4253@hirez.programming.kicks-ass.net>
References: <20230404082255.GU4253@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Apr 2023 at 10:23, Peter Zijlstra <peterz@infradead.org> wrote:
> You can mostly forget about CONFIG_PREEMPT=n (or more specifically
> CONFIG_PREMPT_COUNT=n) things that work for PREEMPT typically also work
> for !PREEMPT.

Thanks for the clarification!

> The question here seems to be if i2c_in_atomic_xfer_mode() should have
> an in_atomic() / !preemptible() check, right? IIUC Wolfram doesn't like
> it being used outside of extra special cicumstances?

Sorry for expressing things more complicated than needed.
Yes, exactly. Wolfram expressed considerations of adding preemptible() as
check, as the now existing irq_disabled() check is lost with !PREEMPT. I tried
to clarify that the check seems to be there for "performance reasons" and that
the check essentially was !preemptible() before v5.2, so nothing should break.

However, what came to my mind during my "research", is that it might make sense
to handle all i2c transfers atomically when in a post RUNNING state (namely
HALT, POWER_OFF, RESTART, SUSPEND). The outcome would basically be the same as
with this patch series applied, but I guess the reasoning behind it would be
simplified: If in a restart handler, the i2c transfer is atomic, independent of
current IRQ or preemption state. Currently, the state depends on from where the
handler is triggered. As you have stated, most of the i2c transfers in the
mentioned states will just update single bits for power-off/sleep/suspend, so
IMHO nothing where not using a DMA would matter from a performance point of
view. But there might be other reasons for not doing so - I guess in this case
the provided patch is fine (at least from my side).
