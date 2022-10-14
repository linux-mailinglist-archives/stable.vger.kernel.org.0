Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD325FF4E3
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJNUzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJNUzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 16:55:24 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FF5AF193
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 13:55:22 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C093A580227;
        Fri, 14 Oct 2022 16:55:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 14 Oct 2022 16:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1665780919; x=1665784519; bh=llldzjFKjIOAcGM0pMzUMZuGuCHJZnxlsMk
        4535qhRQ=; b=FvV1Zz0ZXXDzjioC2bKB4aYwS12xLUJ0ZYg/d9LiAqNL2BQd91r
        RdKxto1QV/FFxoFKwX5IWFUFGa0OPFZZ552OY22qYjM3Du34BmNoRr70ItDCU/PT
        x3buTEiWJHRj9CkxJEkDTqux6PgrA6vDtpJgKWxlGDGvLPE1b17fLlT7u6EhlyeX
        099JBLkKwUqH2MUEXD2qmz9s2rU9pxTp3phWolg12wajQYWPBJ1R+y/azn9Lb1ad
        MkEk5514SAJU2AD+kSKKCWmCeCz4qVtKLoTz09Q7Lv+AQzRpV9rsp+4RQh3gN0Bz
        MSbnGnAqi5X40KR3VpdfNGj5ucCB8299uGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1665780919; x=
        1665784519; bh=llldzjFKjIOAcGM0pMzUMZuGuCHJZnxlsMk4535qhRQ=; b=b
        5gaJNWIEyWQ7pPCsBGWSSoCCGk6oLftmBBBtD5A5AJ2oZIRCNeFGrjnW4N8uljIv
        N1k5UwyF18CrF35l+N9WVPtstXhOVEFG7PYY1CslM/GdEYYs5AG7RjP+HbGzT7ky
        asvk0Dwa8HpN1u85Mvo1a/YNkkewoQPHgislNk3Z5x2jWe7YGZuXiXs9M3I1ZlGr
        1SzW4uSenCXeKVH1eKvLbZrallgKmiuxnwhJNZiMpOb/JbwHOVdVNVRPBBzg2JQS
        PeJ83V1b5AwyCB4LLIDGZQBBbeDR9/+J8l62cWo5hRGICCkU1xEZH61vws14aQ9D
        d9U3O+JC96lA65k2WrkNw==
X-ME-Sender: <xms:t8xJY_Z22J1fpwU1c6uc8b9oRclig2NRnm4LLf8B3sUb7dUuLHBcZg>
    <xme:t8xJY-bGyfYP7xbCFv__hI8FyQltcF5U6ck5wW6eU2QducSPbpC7EwDdkOVY9jhVC
    wRIawmkchi4dAYT2NM>
X-ME-Received: <xmr:t8xJYx-sBCSHAZdaUMkvPHRnW2V_GbGsQhrXQuIU9Zxw5aqKkNsd42ucSLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekvddgudehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfggtggusehttdertddttddvnecuhfhrohhmpefvhihlvghr
    ucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtthgvrh
    hnpeffvdekffffffekteehgfdthfevteetudfftdeigffghfeitedtgeegjeehgefhueen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheptghouggvsehthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:t8xJY1qPGFwmquNy2xlVnoRMre2ZnmJ-KCRYr7OUpFeZaAg7osLKJg>
    <xmx:t8xJY6qpe7bTLr9W3kb4RYyBO8RtInGo3tROtT71idPsGBpB41FnMQ>
    <xmx:t8xJY7SVtCJxmHTZYDmKmv1ZfN1WV5KbFFeGHtp6MMhCZfHj7L9uDA>
    <xmx:t8xJY_BrjNn9NABRIDvo7lxDvzr0GXOW3JQRK1Og5sz7nfxH1FeUtQ>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Oct 2022 16:55:19 -0400 (EDT)
Date:   Fri, 14 Oct 2022 15:55:03 -0500
From:   Tyler Hicks <code@tyhicks.com>
To:     gregkh@linuxfoundation.org, Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Process question about dropped patches
Message-ID: <20221014205503.3w2ge6srfpk6gtlt@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg and Sasha - I'm starting to think through how I can monitor for
dropped stable patches that touch certain file paths in order to help
out with backporting. I've come across a few examples where Greg's
automated emails point out that the patch couldn't be applied to a
certain series but then the patch shows up in a future -rc release
without anyone submitting a fixed backport to the list. An example:

FAILED email: https://lore.kernel.org/stable/1664091338227131@kroah.com/
-rc review email: https://lore.kernel.org/stable/20221003070722.143782710@linuxfoundation.org/

Is this just a case of one of you manually doing the backports (or
dependency resolution) yourselves or are folks directly sending you
backports?

This isn't a problem for me, BTW. I just want to make sure that I
understand the process. Thanks!

Tyler
