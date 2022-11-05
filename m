Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6075A61D995
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKELIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 07:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiKELH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 07:07:58 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D679101F5
        for <stable@vger.kernel.org>; Sat,  5 Nov 2022 04:07:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id 13so19242815ejn.3
        for <stable@vger.kernel.org>; Sat, 05 Nov 2022 04:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VemgyqMjEaxGRFsa79+ERn9BrIYgjBTiK6GtMJc7m+8=;
        b=pdJXiwQPsusmj+8M5WaqD92n0Im7URlSloNaB6UupoLwAneODBKkMUtA+RdYvfy5kt
         E5OFi8QS/DedurksGjoUc4PwwSkM7fJEW8Dt06AY/PdVL+njsAtFNsdveRkEdrLiHe4c
         khnlOI4nU0aZXZyVkKX+t4b2Fic7nGSSgG4dBUHp/l881BNZfBFOSrTC5sUcjdxJu1zp
         Jd3DZiGP/xcEuNRp2fBzszRcxy0JaPnB68VPbXAvsbCSbzCG/hZg43ncjgAEo0nDrGjO
         CuyOqSVnjY0M6zUYb2FpB81IShO+JOavjnzaxsA1MWT2hgVelhF1VH2IfwbzR+UVwgT6
         wsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VemgyqMjEaxGRFsa79+ERn9BrIYgjBTiK6GtMJc7m+8=;
        b=AGgczg8ZG6en7UQrOZEXJVP6JTF8CieYCCX2yPs2LFicP+GL3ybKQ+FwJAToVtbEU6
         32eOtsunVSxJokLy/GBiBu50h2j+GoZf/TK6tm28T2+8kq4K1niIo5T0br/l3HMKNJFy
         szmPXTRi/xnJBEkJrnq2y14ex0dU4/FGg/1qTwSUUg11Ziq7guSX9LxGZcoZRUytj/70
         NA98AX4a0O68FobmI3RjSpyIYgZN1zjWdR61UvUGwYbo5+2lg2MwoBq+OUtMJudSAit6
         MjK7y+xyvhiSDln+JO67UarjcTTcyv588CWpGQj80n8h86Mz6DOIr9u2kSMlVi9X2V+e
         MAwg==
X-Gm-Message-State: ACrzQf0mI7SEqOTy/KcFAN5h0/nlXMJuwb3J0v59CBWHd4Uwwh9IMidB
        gWFlTYxT+jemsNuivoEE0NacKtG87t4uY0bcH4M=
X-Google-Smtp-Source: AMsMyM4vMIhLWjMfhnElyvipTT8rR/R+dBkA8K6lLGCJcHkH5OXfqD7dTVtJ6/moPMZ9lCdzJnxgpLy8R/w7nubf2Tc=
X-Received: by 2002:a17:906:e28e:b0:7ad:bde1:3cc9 with SMTP id
 gg14-20020a170906e28e00b007adbde13cc9mr34660907ejb.482.1667646473582; Sat, 05
 Nov 2022 04:07:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6408:2152:b0:1c5:3ee9:c49e with HTTP; Sat, 5 Nov 2022
 04:07:52 -0700 (PDT)
Reply-To: mmaillingwan391@gmail.com
From:   "Mrs Helen Robert." <rmrshelen101@gmail.com>
Date:   Sat, 5 Nov 2022 12:07:52 +0100
Message-ID: <CANfGfce6gw6LJSpeXfdPn+Wo_2eh=qQ_A0kTvJa5KTzFkZNquw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Friend,

I warmly greet you

Please forgive me if my plea sounds a bit strange or embarrassing to
you I am 63 years old am suffering from protracted cancer of the
lungs which has also affected part of my brain cells due to
complications,from all indication my condition is really deteriorating
and it is quite obvious according to my doctors that i may not live
for the next few months,because my condition has gotten to a critical
and life threatening stage

Regards to my situation as well as the doctors report i have decided
to entrust my wealth and treasures to a trust worthy person Get back
to me if you can be trusted for more details

Sincerely Your's
Mrs. Helen Robert
