Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1351E5384C9
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239153AbiE3PYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiE3PYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:24:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D32816E6AA
        for <stable@vger.kernel.org>; Mon, 30 May 2022 07:24:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y8so11430865iof.10
        for <stable@vger.kernel.org>; Mon, 30 May 2022 07:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=NbqxDIfbgJ3MqmIYsJC5mVjaDxSkTWvC3kPoDVHx4JzwZbpS9PNN5if7c29NSZ1sJB
         f748WH2yAajK5ZcxxhXypaHitkort6LILed9cl4irwdGPwVFlpX9AkTr2Mja958VRSek
         qJQ/S2UJ/mcH33fo7+iitzWEfRfsJLZOKNeCLEV5Ejg1TlbMSXMphHmvbctkGozedLMF
         jgL5p2nws6aUnQQJIpMt+a5eemymIUXiMAge2uC569EQkBNKwj9hF5GPWTfL4FZABal5
         bSX0/kJq7HKgVN9I+/juXlAdYtbdpienxpvSlxQG+6DpQindHNtjhL8DNUTmcvjGJvhV
         /kNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=LNlHxRr+i6hRTfHnHT7D+DDjcF9Gg1e13jxvEwNLYFW4RRIyelx5Agfq/ynvJk0fxJ
         esqJKHniB4+lhbsA1Zm305NC8A9QgW8vgtVx+ZSPhq8Y7pSLcmz+YLRFi+bCVGDc3XH7
         BEypQOIKJ6+vGJj1yFwRe3BtmwBqOnhq8WxO7JWE9Lv/sCvOzEjbRl9VuavufwS6+6wu
         nEEDhOdk7/j5p+ywd9TaXZLOlr4/EBGsCYrHRUMlsBngp6rPOe+6cfO/4fIMv49Wf0su
         a66pMpMCve3DS5dxhxi5yrrPE2EsyZ4L7DnaGuf7nm7LSpdhfNqDhfZLMu6Ttl3qtT3W
         N7yw==
X-Gm-Message-State: AOAM530G8HxFp8vAbGg3mjrN0egFLoiNrFp8E2KiudMkkEf6fA/EAksJ
        jmB3Jvm90Ha4aReQ5etvFDx3piGAJJtsDrZzgrI=
X-Google-Smtp-Source: ABdhPJzg6KrabGVEkgnEr4HNvCPzSqI/oaNQTXsR1hl2LvfBX1gjy264CVcX8XoPW8bcnnZPEUFZqfffzIuL4LeOQFM=
X-Received: by 2002:a05:6602:1646:b0:665:6f07:bd4a with SMTP id
 y6-20020a056602164600b006656f07bd4amr15942297iow.111.1653920695415; Mon, 30
 May 2022 07:24:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6622:f06:0:0:0:0 with HTTP; Mon, 30 May 2022 07:24:54
 -0700 (PDT)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <koadaidrissa1@gmail.com>
Date:   Mon, 30 May 2022 07:24:54 -0700
Message-ID: <CAOh7+P8pmKdAt7XCLDd5RHaMka48-aY9v72T94WC3g_QUan6Lg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.7 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d43 listed in]
        [list.dnswl.org]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [koadaidrissa1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [barristerbenjamin221[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [koadaidrissa1[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gZGVhciBmcmllbmQuDQoNClBsZWFzZSBJIHdpbGwgbG92ZSB0byBkaXNjdXNzIHNvbWV0
aGluZyB2ZXJ5IGltcG9ydGFudCB3aXRoIHlvdSwgSQ0Kd2lsbCBhcHByZWNpYXRlIGl0IGlmIHlv
dSBncmFudCBtZSBhdWRpZW5jZS4NCg0KU2luY2VyZWx5Lg0KQmFycmlzdGVyIEFtYWRvdSBCZW5q
YW1pbiBFc3EuDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4NCuimquaEm+OB
quOCi+WPi+S6uuOAgeOBk+OCk+OBq+OBoeOBr+OAgg0KDQrnp4Hjga/jgYLjgarjgZ/jgajpnZ7l
uLjjgavph43opoHjgarjgZPjgajjgavjgaTjgYTjgaboqbHjgZflkIjjgYbjga7jgYzlpKflpb3j
gY3jgafjgZnjgIHjgYLjgarjgZ/jgYznp4HjgavogbTooYbjgpLkuI7jgYjjgabjgY/jgozjgozj
gbDnp4Hjga/jgZ3jgozjgpLmhJ/orJ3jgZfjgb7jgZnjgIINCg0K5b+D44GL44KJ44CCDQrjg5Dj
g6rjgrnjgr/jg7zjgqLjg57jg4njgqXjg5njg7Pjgrjjg6Pjg5/jg7NFc3HjgIINCg==
