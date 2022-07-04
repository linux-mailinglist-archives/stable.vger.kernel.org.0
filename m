Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BF05655DA
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiGDMsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiGDMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:48:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099EDFD0D
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2CC3B80DDC
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26145C3411E
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:48:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YsG2WlPz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656938891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TrooSSmukc16LTcVKdgqf8g09ijeVLZ5FuYZ8uyRZ5U=;
        b=YsG2WlPz9xiu+4xRNlNjiK9eIxy6iuOWlGibUl/C4H66WYrrOqB1JMJsg6Ge7ki99n38T0
        apPcMrBAWW/WiPy4l6JXp9INbJhfbjN+gS5UQ6nA3PU0F46YaQdqLZ38CvazNRVhUJv1ud
        3apmPsklQ4Pz/smD5G0MLgjGgW3lE4M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 420c54db (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 4 Jul 2022 12:48:11 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id x4so8895180pfq.2
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 05:48:11 -0700 (PDT)
X-Gm-Message-State: AJIora+e+X40qCImlDXxO+T1vpsHYcHhAodDE/QWvysfUqjfjHtMIebc
        YTt3bwD16FaE41zUZQClFgNH5Jw+6qYG3Iigw8A=
X-Google-Smtp-Source: AGRyM1vzO6fIMeZxskIMyR9lJclArhPfaE1FRAiaKLl5A+dx2b5WvaT56/sxVgeY13ijmXOTqZPwlVI/kUgrX+lzI1o=
X-Received: by 2002:a62:a113:0:b0:51c:1b4c:38d1 with SMTP id
 b19-20020a62a113000000b0051c1b4c38d1mr36425934pff.13.1656938889654; Mon, 04
 Jul 2022 05:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <1656920231245244@kroah.com> <096c514a491189b7ce91da03d8b7ead5@linux.ibm.com>
In-Reply-To: <096c514a491189b7ce91da03d8b7ead5@linux.ibm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 4 Jul 2022 14:47:57 +0200
X-Gmail-Original-Message-ID: <CAHmME9p6afcDXSmCQSHuuPytAg5Lv=ZJO4uiftZFa8C-isHHgg@mail.gmail.com>
Message-ID: <CAHmME9p6afcDXSmCQSHuuPytAg5Lv=ZJO4uiftZFa8C-isHHgg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] s390/archrandom: simplify back to earlier
 design and" failed to apply to 5.15-stable tree
To:     freude@linux.ibm.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, ifranzki@linux.ibm.com,
        jchrist@linux.ibm.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Harald,

On Mon, Jul 4, 2022 at 2:45 PM Harald Freudenberger
<freude@linux.ibm.com> wrote:
> Well, it does not apply because the context for the last hunk has
> changed.
> Here is a very slight reworked version which only corrects the context
> for this
> last hunk:

I already sent in a patch. In fact, I sent in backports for 5.15,
5.10, 5.4, 4.19, and 4.14. (There was no s390 random in 4.9 at all as
far as I can tell, so I didn't backport it there.)

Rather than jumping into the wrong branch of each discussion, it might
not be a bad idea to read all of the emails in your inbox and then see
if you still want to reply.

Jason
