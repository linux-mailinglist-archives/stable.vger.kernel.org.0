Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A6765E02E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbjADWpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbjADWo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:44:59 -0500
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC4442E0B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:44:58 -0800 (PST)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-14455716674so41425525fac.7
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 14:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=bIvXeO4Mj2vxG1xzoD857JzcNYfyRAkxCnlrQdShaibm/rGHHiqrfelqzS1wLbc638
         cVLQsaIhV68pENM0f69tmtijPn1Fi6J/DaadrFQd7o4xGR/gTIU89mUQt5tnsN7eOJx6
         QRgRhoJ7fNlcNt/xRC9JDtXBo4qeglVSynZlbj0el8hRIr6oLuj6v+iGeZA3mqHq0MaF
         PDBApaAfGgKoDMVXPen3ZjFu+YJ0pKO4zsEBuCrw6LihhDZ8okYDE2KqyJcp1K8+Rk6F
         xXXQVI2/G4T5xSo1CQnqkXJMrsVgl1W6hK1eJgjKdy2lL9VC3q/mjC87rcUCPBpzCKfq
         chjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=1YRteTiK2QzMPG/nNnQVcQEHclKPUAP2Lo1LvotzUq8BksO0zovdAjCkW70qSqjJSe
         aMl+GqmPRAq788mtcc6sX16lcOlIyzE5wZS9BAsFcZ9juoPyrDNOI3eZl8UNzPUpXDMZ
         TdzfT4hnV7oLooRZSuHEjpAhGC2UCYLntUGdvFvzhgHzKfEIfWjB1kqfDp+bsocTI96p
         Ssf0lps+6PNiZWqtOqCgY96RrLUyvQRiUEXjiQ1+VNzRn/U4SRNluCKWAbALNIlyYE7/
         hSBCYRJDmOML+15G9htUSOujC5uWrHkIG6CdVsk78Z8B5zZh5DTdtOrBLwG+7eOy+Uhm
         M15g==
X-Gm-Message-State: AFqh2kpaJRJ0haxplIb7c4Ft/K+j74kMeK0CSATOF+NkXepEBG6ciRY+
        k9R9e9GEamT7cypgI8nJ8FR0LsJbuigGPZZTf6I=
X-Google-Smtp-Source: AMrXdXslGLLlOkPtAHVEZM3AK6rULv95xVo/pVcWGjge6Oz09JrRRdjtHCfBTobP7caAFgKgk3dkmUWboPSAfIYXpiM=
X-Received: by 2002:a05:6871:68c:b0:150:60e7:8d83 with SMTP id
 l12-20020a056871068c00b0015060e78d83mr1238945oao.163.1672872296795; Wed, 04
 Jan 2023 14:44:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2307:b0:577:153e:6778 with HTTP; Wed, 4 Jan 2023
 14:44:56 -0800 (PST)
Reply-To: lisaarobet@gmail.com
In-Reply-To: <63b55bf8.050a0220.2b2fc.308b.GMR@mx.google.com>
References: <CALcNZmGVi_msZ=XLrJ4opKeqNvOk5vpM_0TdvkOYG+GWregYyA@mail.gmail.com>
 <CALcNZmGVi_msZ=XLrJ4opKeqNvOk5vpM_0TdvkOYG+GWregYyA@mail.gmail.com> <63b55bf8.050a0220.2b2fc.308b.GMR@mx.google.com>
From:   Lisa <ws6392981@gmail.com>
Date:   Wed, 4 Jan 2023 22:44:56 +0000
Message-ID: <CALcNZmFWcqOm3PnYO11xP6o-qUG9kD4PMEfa=2DcKqkE4FfKjA@mail.gmail.com>
Subject: Re: Delivery Status Notification (Delay)
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4910]
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [2001:4860:4864:20:0:0:0:41 listed in]
        [zen.spamhaus.org]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ws6392981[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ws6392981[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Just wanted to check in and see if you receive my request?

Thanks
