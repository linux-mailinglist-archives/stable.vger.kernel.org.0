Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA91960C5D9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 09:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiJYHvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 03:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiJYHvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 03:51:52 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A06167260
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:51:51 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d6so20500436lfs.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=LCdhk8v8YuQu7l8Ioow/8MkMud81Dw66IJ/QDpImXiZ3QHOjApQH5qWh8bJO+zEPTN
         iMpPMF4kP6uIS7Ms8Px3wRAIB9QxQNq9ShS5BMdr72ZUU0gMDxbLx86exdNDADxJYxK3
         1Zxa7PuspICcJ3ubUPZx7a15ZVRoXpaX/tQHnkD8iAH5WZYEx3q9/nuMSWuCSfpxv80g
         i4u/YpffIt/DgWbI1WyMujlgVr/uWO1Mazem2NTEIHUCMWpBEM/UyvSOTwKW8IelCe85
         LiZzAcJIpMfrrUZAnDWxolXu4rGl1k7Qlgzgw+NwpEREMh7GMZAjmrd7KYbPagYHtFRt
         +hBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=yV3eyZ4CxbN5mOOhpcXctLQlIUY0NlXBb0fbIPQMmqxjBY98URnMiLbmjmOmqgf4h2
         TVdVUBNYUfbQOaGHyMkjSmJtuj8xd9BFPwlLdRXn/ey2bsFZSCWoHASmiq+d3469ROfz
         fm8Uhp96jC8pgl8R4ij06y2k9w/PyyvfnNg/nVCugJtVemv8YCBkUi8CI14blSrvZRkP
         492DfknqdglTSCcvgVV9DI2fGVOQhOS+W3lE5S3B9gXs9hTOtU1+5IeyZYLwEVdx2R4h
         QQRjUfum3S9o8iR2IqPDKGhUVzmYpP8k8aCLQvAd7DukU7R0pvIULQVIK2H4ikwtfgU/
         MA5Q==
X-Gm-Message-State: ACrzQf0CYJm4uJ19hL8Zn7WwF1whdaG5TcwqsHj1qT93HQj1dYwZHc1T
        1X6u4GK6FbsJPysl245/BVnCFx48T3gQuvGOWzHZPK353Bg=
X-Google-Smtp-Source: AMsMyM7Cq4aHuUZwwyPh/uWB3dxPYS7HFSs1GI+ZTmuSglOK2cChzBe4sBFn+CQMc9a6tJ5DJ0hkEJmnBOj+aYIXpfs=
X-Received: by 2002:a05:6512:2397:b0:4a2:55e5:4909 with SMTP id
 c23-20020a056512239700b004a255e54909mr12950542lfv.549.1666684309426; Tue, 25
 Oct 2022 00:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112934.415391158@linuxfoundation.org>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 25 Oct 2022 13:21:38 +0530
Message-ID: <CAHokDBmqLmT8+4Vn1U2wnu=iFzxyQamiinngvOXgb05ZqtPMiQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
