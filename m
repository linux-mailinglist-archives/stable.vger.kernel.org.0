Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B828669D64A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 23:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjBTW10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 17:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjBTW1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 17:27:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902CA1DB88
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:27:24 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h16so10158910edz.10
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGb7bXbv+VK83u/mqEKfzq/DoJRaeJ4x7SggiYRiRSs=;
        b=E5s1fXg+twf2J1udvjoeNuYD+qJmRTaRCwEvXwuQpB452HEy28SYzKJn8X2/s+fsvB
         4UMEas+UmeWvgW/T1y7B874127q1JrSs5TOs087RgvN8atnIOCFdjc/Pj5w1AI/GVIno
         U9iutaEpe0/qoc3SEw4X77d4PO/xoEC2JSj4sYLkv9M+S5NNnRr7rmh/s6o6LH3yAwHP
         q7xYJLrUoCEYPFwR9SsnGxGN6oJ0S2F4R6Tpukhrq+UGLZVTpV3p+83OF5JbRhBmNJnu
         JnNgrr8TOXdqvnXwJ1BD3pCjmKgA5+oT0nanOXuGYqzQdyG6agEtc2d3Lt/FzgZ+mAtO
         /nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CGb7bXbv+VK83u/mqEKfzq/DoJRaeJ4x7SggiYRiRSs=;
        b=BUA6lfkp6cpxGSuaQCV4QnQziGDyi0sHWbNnOOAgU8JUh1PPrDiCHcH8LuM+XZyILS
         OF5wx/E1m6GC+U6lPHW8M9gA63oUP5sj8fMQFU0aHppBowOUP8T1IcXrY5iw8WXnZDSC
         ALc9mWu7uynRHjFeet/i0ZnvgTCLqBNjs4lKT91zArYgciBv564bGOPq1l1tHn9KHhDy
         VWlKD+Zh2UvWtX4dPBFBgq789HDMWWl4bCSt0T1AXHlrIzSgZv9N7BAkq0mc5Pec0+tT
         xFKK8AVDRwPya6Ie3giS7my8ChMnUctgpf3pZuKk5ANrMIZTvRlNk0Lv/l1302n37cod
         AzSQ==
X-Gm-Message-State: AO0yUKVIs+qGOQYdS1dwdZVn8o+MX2RgJJVnunCZHpy7TvIP/s8wGpnB
        40t07xP06jA04AezJxxifWdeCMtVrBJq8eSBRi8=
X-Google-Smtp-Source: AK7set9urYvu/RGGAiddi2OpJsGVHkGytpVcFvYRjbO+r+89lVVdL1LYTqvPEpM7DG+tXh1GR/UrMpI4lVmiBf6iFGE=
X-Received: by 2002:a17:906:a292:b0:8b1:28e5:a1bc with SMTP id
 i18-20020a170906a29200b008b128e5a1bcmr4812422ejz.5.1676932042990; Mon, 20 Feb
 2023 14:27:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:14ce:b0:8b1:3a93:be15 with HTTP; Mon, 20 Feb 2023
 14:27:22 -0800 (PST)
Reply-To: vaughanrichmond1@gmail.com
From:   Vaughan Richmond <aliyudalha9@gmail.com>
Date:   Mon, 20 Feb 2023 14:27:22 -0800
Message-ID: <CAGP7zvyCR-+5wMN=GRqP3DSX2oeiXmwPviTEWagfWiRX4cr89Q@mail.gmail.com>
Subject: Re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9460]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [vaughanrichmond1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aliyudalha9[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aliyudalha9[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have a business partnership to be done with you, Kindly get back to
me via  this email address: vaughanrichmond1@gmail.com
