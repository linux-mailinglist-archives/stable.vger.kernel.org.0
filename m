Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768F7548163
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbiFMIEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbiFMIE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:04:27 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880FE165B4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:04:26 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 0EDC6320090E;
        Mon, 13 Jun 2022 04:04:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 13 Jun 2022 04:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655107461; x=1655193861; bh=sjTbxuFS7c
        MPACAkyql+u/J5OPQ62D6eVxZANUx55zg=; b=HetBtHjcfTGzG+Q8l3v874TT+d
        VMBkiKpoFtxJ29T16rO3v1U2kmWkBa2s9moe6QvVWUP7txuqJQu+lvHDJF4OZX0z
        3Tf8a3h2rKblEvBbEdNSwmzevBmxKH219UguNvoQujE3YsPoaKsI+D+PKrhHwLU4
        r0Dq9rE0iCqYkVcdW5cLa22LfQsoJk6AI9VcreDibaVD5SzwGlL0Hzk3XEWdq124
        ampjv5gUbcg4addaFF7afEAMXb2qG+NqjhWG3VNCz7TzvL1OK9jkYuQo+2TY14sj
        nDHs9IXibrSzCgwdoer3gIbQ1ITmOC7hu7bkBDfsUPkSOWx+RK8jNBl4UsUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655107461; x=1655193861; bh=sjTbxuFS7cMPACAkyql+u/J5OPQ6
        2D6eVxZANUx55zg=; b=TTyrISfiohvo3/m9OFM38pRJeFl+nBdK9BUUWr11vxho
        JUH0biimuu8bzvx/yEmJLl1lisHfMY+M1B78d94RL78g0AvFsVgc7Z0chdoOfEmt
        Pf3zP2LoSRVvac73G1KTqHZef8RzdYQ5vT4oNB6nqv6ykQFpTTw6qFJh32kFA/P9
        7XObWNA0gK9GB8gMnMuu08vG4Iuf0JaKopaHFzhMeEncM0DS6nwMHQhrZOWTpCso
        9aJUGQky+EwamSPYicGkNjQVBVbqe8MpnPvHzzfk7NnghmDWkVcWPohB+Yv32+Ht
        ocMHzK6yRetAq9GSCSSJN6E//bJaIU3iCIztyKvogA==
X-ME-Sender: <xms:he-mYl3ORxFfQwZYYzLeuHO8ANfgO-w6NEnbzELGCjRSWYldfNxqag>
    <xme:he-mYsGHrApEE6-LwUjwpX7_R--RQQyyL6OBBlw6RxsUDOeG9_0IpwfLwh0Rh_BZF
    SbMsMrSW_c8rA>
X-ME-Received: <xmr:he-mYl6LuQh7qgWFrxO61bpis1z0bGxTtTOtPy9YlMgR9Srg457IvWMenUjK01tP76t5nl09OU-EM5D3Dk5Q0ZJNhlhT-ayp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudduiedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:he-mYi03wq2RcKr5cM7Db-aig6i7g2Vo2empno2eBeMFxEN7e60OZg>
    <xmx:he-mYoGwA5kbqJ1gU2HI1r2KCAKp3KgErQsciZmWvzYFKQFCPvn_CA>
    <xmx:he-mYj-p-IyKvEdqqXCFqKBP0yblF-BNN_LLsQ6nc_nE5Q4xMi8AnA>
    <xmx:he-mYlfqKNvHJyTEM50Xze7i-0msYE8nqYKnujWAduCUWtcHW_VMBQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jun 2022 04:04:20 -0400 (EDT)
Date:   Mon, 13 Jun 2022 10:04:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, swboyd@chromium.org, dianders@chromium.org,
        bjorn.andersson@linaro.org, djakov@kernel.org,
        quic_mdtipton@quicinc.com, quic_tdas@quicinc.com
Subject: Re: [PATCH v5.10.x 0/2] Fix SC7180 suspend for v5.10.x
Message-ID: <YqbvgW04785Yeud5@kroah.com>
References: <20220608205415.185248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608205415.185248-1-elder@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 03:54:13PM -0500, Alex Elder wrote:
> These patches were back-ported to v5.15.x, but we might as well
> include them in v5.10.x too.

Now queued up, thanks.

greg k-h
