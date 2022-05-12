Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61218524B91
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 13:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353268AbiELLV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 07:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353504AbiELLVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 07:21:23 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BCD40E50
        for <stable@vger.kernel.org>; Thu, 12 May 2022 04:21:20 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ebf4b91212so52058407b3.8
        for <stable@vger.kernel.org>; Thu, 12 May 2022 04:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=OGjovOLLCNX5QV/XTVfdAcAkHFV5TFmZScvINXsyNcw=;
        b=pOU0ONcycMrODWDOn14LqWpaMFNiNX2ks49EtVmZJ7KjdusgpZZR/9V/QNh+BX5U4i
         6V6aMU9BxIwQRCpQjiPulS/ua+jl27LVvEBtXmlCR49AOly0RMFUbCOvx15+gNhjOthw
         mKz35xCIUOBTxXQWWpGgh3+TkAViSK9wo62sYUdJjsgQep5R97/G+NmG+1jHbPMFMTUs
         XUi5XiIdpSyUBcj1PWFATDY7qHmWDtBxTa68o85dokTizPHvRjhrcqaEKnZhtzB4pNHu
         Fu/xyHmfwX//m3FWhP3ZPCYKLiNnk/0hGpjHAtIrT93rHfiaeiNoPkQoMM9AVen+SIJv
         mQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=OGjovOLLCNX5QV/XTVfdAcAkHFV5TFmZScvINXsyNcw=;
        b=louzpgSxt4UohM2YP4GTFC0d/qeUElLVeKyg4fcsvywOSM6rxLDBz4lfQVbF4Map6/
         DFWPDCpcAzZMiZ+Blnks4lvJ7aSmJRbx9n2swL4w/pvii9CByqA3lm9ruVE+G2IdHDR8
         4BcJJy1arg9YoPBmUy32B+Dcd4tqnBKOekCB+ZQ64Ij+hdmCMwOWQgBMLiCe7+/Uc90W
         JImvkbnjJ3l4dzbL7KFGmRq9L3BWiS8e6mvPFNCWahldlwWnnmHQH2tL8U/E/h4Jy6G+
         sR9SMIWt97f/yjn5f8Y0KomWE62N/1lvHcHsgp2pkZtzqxSjQ+wm0ILIeugddu6K2Z6/
         TSDg==
X-Gm-Message-State: AOAM532OzaGRsuy3hzMTHrJRB7tVzsYC00k2BjPpwJZN7TY0rht9tKRw
        hxrapBhXx8pY0UAJVadn0FAWZMkEotLhbc8OFw==
X-Google-Smtp-Source: ABdhPJyHXVGh/PUtBX2c45pIy56B6FtWWqek62zmTW0i3oYXGH4xKeNTkuIUs3+YdJllEVm7bqmlWqme1L0skbV4Kvo=
X-Received: by 2002:a81:b044:0:b0:2d6:bd1f:5d8b with SMTP id
 x4-20020a81b044000000b002d6bd1f5d8bmr30040114ywk.27.1652354479494; Thu, 12
 May 2022 04:21:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:380b:0:0:0:0 with HTTP; Thu, 12 May 2022 04:21:18
 -0700 (PDT)
Reply-To: rolandnyemih200@gmail.com
From:   Rowland Nyemih <happypalama@gmail.com>
Date:   Thu, 12 May 2022 12:21:18 +0100
Message-ID: <CAJoeney-SoS2vkp+OZ3TXf8bUJz+qkgCgo7=uqjxTp4TzEfj2Q@mail.gmail.com>
Subject: Rowland N.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4311]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [happypalama[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rolandnyemih200[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI,
Good day.
Kindly confirm to me if this is your correct email Address and get
back to me for our interest.
Sincerely,
Rowland
