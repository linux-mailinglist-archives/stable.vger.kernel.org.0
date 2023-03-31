Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE8C6D1AD6
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjCaIwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 04:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCaIwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 04:52:23 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07E3D50E
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 01:52:21 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g17so27991989lfv.4
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 01:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680252740;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYjuoS7ythtwd/oZ/BkScT13afQoSF7qfo8lAF05rsk=;
        b=jWeFfFoluR2/sH2CZRlIPIDl01Sf4Tuu0/5huKC/dVuKXFk8cNUsRoGv8jyI59F8rp
         ubs50kMIFl57y7hIK9wff5fUGCOvTLDBIX992dXmWgD3XZLJOJb2BsPO4hFZtLiVE0l7
         tm3Qot14YJIoXfcQIm7vg6pnYUD7n4vjaJM36iroMM7V2c2wNoFmr2opxKd/u7eVMBVi
         1LhCIvovdVdp8bzpN7N6YLpScIElEY4lFwSpQGio/WP/eGHQwKiUB8jPEhvp0qh9p5Kr
         R10vEZlgL0EZ1LGoXcWDhXKrI/IGWNCSOuUyRj1ENIfU6cH5GCJepH0y9Mh0E7hWffPO
         kvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680252740;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qYjuoS7ythtwd/oZ/BkScT13afQoSF7qfo8lAF05rsk=;
        b=RVWCTkfY1qSju2y5Q1s8Wn9QIunm/g4dC+oWnlwx6lYUhcd2THEn87gxjxiQRReDLJ
         iZUExmT4XW6Ep4A9vbJujuVLKI9gUpZAzM0undt5/GnJveiEcT4edKfaUUgIHDp7VtPq
         O6gc2M9ReqcdnYUQdD+PDD+vqB8z307d+eiW2A0UydzpzX1KUl+PVlOf60laxPQCyeEt
         xfrUTsJ5xwiITtryjMsJJEOkWKJZrFMCMA5/FQI3iV6WSU1OMuM1rGFmZZ4p7VL3QXe4
         rqcoHKoI3ODKae1NefZbQWN4O8qTyRXe2jhmWtRbiP11w6Q2MLYswWNKGVpsyaIPvAqD
         AIdQ==
X-Gm-Message-State: AAQBX9esMydMGYx71gNkUvGI81COiHsBizwbIxx+TGGQsCPcAXz3flyI
        bPl6hQm0TCzr/rZHCJ7IfFWR6vA51G27edeTJUE=
X-Google-Smtp-Source: AKy350aWsSnjnHSDuXq2jvG7G1pLTpyVP/r3RARkzjAJwGob84nMqbkSYRfBM/iKqzAgcof5/eL2iI9j/EU9na+LWfY=
X-Received: by 2002:a05:6512:3cd:b0:4ea:fac6:5334 with SMTP id
 w13-20020a05651203cd00b004eafac65334mr7674056lfp.0.1680252739668; Fri, 31 Mar
 2023 01:52:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6022:61b:b0:3b:32c:d1ff with HTTP; Fri, 31 Mar 2023
 01:52:19 -0700 (PDT)
Reply-To: saraharabian68@gmail.com
From:   Miss Sarah Arabian <mariedoulce99@gmail.com>
Date:   Fri, 31 Mar 2023 10:52:19 +0200
Message-ID: <CAHHAKwi4Wk3eLcWGdgyC_3MQjQr-BLOP9CvgJGg3FEb0LOmnsA@mail.gmail.com>
Subject: Can I confide in you
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:132 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mariedoulce99[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mariedoulce99[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [saraharabian68[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please can I trust you?.
I need your assistance to help me to invest my inheritance fund in
your country and to help me to come over to your country for the
betterment  of my life and continue my education.
I will be happy to hear from you, then I will give you more details.
Best regards,
Miss Sarah Arabian
