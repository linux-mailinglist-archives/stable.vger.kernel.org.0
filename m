Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F25185DD
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbiECNtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbiECNti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:49:38 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62A9377EA;
        Tue,  3 May 2022 06:46:01 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id ED7563200A6C;
        Tue,  3 May 2022 09:45:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 May 2022 09:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1651585554; x=1651671954; bh=GgYcomwsds
        RrYxxul1oPdKhHbYJJh/adytBDmH6b6r8=; b=JS9/m4h3R1GYfScDhMAw/fjb8N
        evLe5K1ZVWBrDOLjnFibwjSn1w+4rkVkV97FngyaYV9Qohf1l9CvNkHH+RvdfOW8
        p9ExhEmiCc0tlV4RZibMnfmpPxqRQWdrhnuWUyncvBN9Dr2M0x0aojRPJJRfJd8b
        2j5MDoR/34VF1d9abBXaXpcAkXUsGOq+QBSBqBwBSyggbk6R2I6XCZ4VFFycTAgY
        G6H/FwJREeXnu3Gdt60LM9ZOL0qy8t6Jo5lShjOoUpbgy9IoXyJG7rQUZS/n+xaR
        FNst6EtYrfcJSc0Kht3H8sOSG9UHDwGi3TuOFYoPO8fOaxJyAPCuOkar4o5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651585554; x=
        1651671954; bh=GgYcomwsdsRrYxxul1oPdKhHbYJJh/adytBDmH6b6r8=; b=J
        gq2ay0mVAHxRw5NXHg30eRU9ODiujH3CtnYmYNgAcJjuxy+2frsppmqm2PV+pN6E
        5efnwAOT1nsYabx7RHlTSjIhLom843UQ7JAE7YP7FDe9rxYRd0nQmDy6YZGzKiHH
        l7sHhj5d8lvkDCwr7jfq7KAwjRG+JTIXKfGR0y8eX0O58tHOwQ1oVzKKPq6jbJZa
        62Y4uTU7I0N/jvJL5MGm9hXYUi2HSEETROtBoy9JBka31dYhiCxapSqScTQyWcSL
        uDxVhCW3z5sWaLpGYXlQhltIsRdmm8StubaX4qJkYl7XNhtgGPjNxylyeuK/wMfc
        9jlbRcdvjv15WBLy02XAQ==
X-ME-Sender: <xms:ETJxYutCNK7enlPNtDmjLXka__V9_Kgt019cpYWc7I5SPhIR7qCL1w>
    <xme:ETJxYje8-eKatvcXSlhq1nbMGQ_JOGDyc2fD-mqHO2JzKYeebnw9AcxDjl7kIAQ6G
    V41gdWZ6Loztw>
X-ME-Received: <xmr:ETJxYpzlgi8qmdTqjqCC5gBwcblv_rrOCqGYRBr4BV_4swWQt_-8p5S9M9i4BQqpXK1-9s46aXOridyxaEAsUVbdMssI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdejgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ETJxYpNXuQ3T7Pec7i58mlCZcl9DXHo6BhPgcwXC8zYL7F8rYeGsNQ>
    <xmx:ETJxYu8fYM4dpN7td1VUCvhlK2HZ-bbizbMR3NlQr4Bw78yr91pAFg>
    <xmx:ETJxYhXv2G74jC9blTWurMBvB65n1qMgxgSB_wr586xeFGkeXQ9hdA>
    <xmx:EjJxYs8o2pl9535C46LXdfb4oiKj4oeNIRdUjliQ98xIZWJHodN4Iw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 May 2022 09:45:53 -0400 (EDT)
Date:   Tue, 3 May 2022 15:45:52 +0200
From:   Greg KH <greg@kroah.com>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Will Deacon <will@kernel.org>, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH for v5.15] perf symbol: Remove arch__symbols__fixup_end()
Message-ID: <YnEyEN7B1lBtECMg@kroah.com>
References: <20220503003736.711789-1-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503003736.711789-1-namhyung@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 02, 2022 at 05:37:36PM -0700, Namhyung Kim wrote:
> Now the generic code can handle kallsyms fixup properly so no need to
> keep the arch-functions anymore.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Acked-by: Ian Rogers <irogers@google.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Michael Petlan <mpetlan@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-s390@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Link: https://lore.kernel.org/r/20220416004048.1514900-4-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
> The original commit id is a5d20d42a2f2dc2b2f9e9361912062732414090d

Both now queued up, thanks.

greg k-h
