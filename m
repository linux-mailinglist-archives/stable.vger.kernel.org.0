Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9E661754
	for <lists+stable@lfdr.de>; Sun,  8 Jan 2023 18:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjAHRXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 12:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbjAHRWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 12:22:49 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5CDFAD6
        for <stable@vger.kernel.org>; Sun,  8 Jan 2023 09:22:47 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lc27so5469357ejc.1
        for <stable@vger.kernel.org>; Sun, 08 Jan 2023 09:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcpM41K3Tg/Gq2Sy2fOw39ukTQf5X/VzmfsS+yU67xU=;
        b=cfhHn8oCXCiV4WDXtCRaNs1JJMfwcehT7gvlemLg8bs9rrX4FH2wPX7/Z5IWAc0977
         L9FUbpgZC3YHasohJHiwlsiYqCOEcQp0/dtm29BRijwqEG5oGHM3aRWv/ziB6wvSpbBe
         XpMErQ/kpKpcHH6MvcPIk4DWxCarh/9uUyfIpNOPjfn1Tz+ZjoPZ2Mi4/ZnW8/XNmPcg
         o0bb7c3oxo5K4tVeaRhriOjhIo8uDp82YwDrgUROom/eYUkiDOMiu9RojIwgukTECH7c
         A6c1wel3MJfH0PUh9RRHGVA8iXQuPSfQk82kMuX8G68Mr3JOajZdqORfnEx5L1qpiSeW
         3ReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HcpM41K3Tg/Gq2Sy2fOw39ukTQf5X/VzmfsS+yU67xU=;
        b=xHBiytIZPzrhoqPtqRIANY9YY1n72QnKq0N0ckuYUCNiSZig9oYildd8AemSePmosb
         pioFReLIEjs8yc0rlGBjLdoI6vAVGkCshNIgR9qTr8QbvyqVytw86jvMmFuNctA8zpIb
         4g8TDwjPVtZaFAk2xC4fw91Bcd/HgzM6jVXHTXIUo93UiOTbyZYu46xRmohvXtyY9Ozu
         yJnnN884w4QI7Zv+ziBZWwssx08K/8FLhVYHs4+mCXNOFLS4yNIYcZz71Zmky+6Kr2h0
         F+g9LPISt8t+FgVYtbO5IJhMPWHK/9amhsI11hukPEBJhvd5OEtNNf3vrxYOSdUjHu01
         JcNA==
X-Gm-Message-State: AFqh2kqqCI87xwQ+FW2xgM1UapQW1E6S5Ctls6KkloWUILmHSxagfVOV
        CWiJLzk0XI3MaVivzlaUPqc61+x5FTjolcwoUzg=
X-Google-Smtp-Source: AMrXdXtxqz+jcbOndiZfNK2DFCTpyW6i9PmI4HL//h/pycx6ItUVJH6q4XUd2OliD94ydEYQwiTnse2OKU7Imbz9OE0=
X-Received: by 2002:a17:906:ce33:b0:7c1:2529:5a45 with SMTP id
 sd19-20020a170906ce3300b007c125295a45mr4268561ejb.404.1673198567128; Sun, 08
 Jan 2023 09:22:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:a82:b0:25:e95:32d6 with HTTP; Sun, 8 Jan 2023
 09:22:46 -0800 (PST)
Reply-To: muhammadabdulrahma999@gmail.com
From:   muhammad <markmillerr7@gmail.com>
Date:   Sun, 8 Jan 2023 09:22:46 -0800
Message-ID: <CABLOnKi=wY7=+Do030AToyERsdutf0cudOhKQ-kxKvb6+N65wg@mail.gmail.com>
Subject: Re:Re:Inquiry about your products.!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:641 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [markmillerr7[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [markmillerr7[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [muhammadabdulrahma999[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir/Madam,

An open Tender for the supply of your company products to (Doha,
Qatar). Urgently furnish us in full details about the standard of your
product. We will appreciate it more if you give us with Details:
Specification and Catalogs or Price list via Email.To avoid making a
wrong choice of products before placing an order for it.

Terms of payment:An upfront payment of 80% (T/T) will be made to your
account for production,While 20% will be paid before shipment.

Thanks and Regards
