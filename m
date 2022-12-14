Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E973F64CE33
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 17:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238878AbiLNQjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 11:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbiLNQjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 11:39:06 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40EC5FD4
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:39:05 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 62so2327632pgb.13
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LbDNBydaewl5dltimDBqmtpJAJq+VfTZXoANK7KfgaM=;
        b=FfGyrKw/pmdyACIFzyBjx3+I1RbAhXpY1KnMvcvd+IcY08hb1o4LUYI2jEIuzO+mFU
         IgAhBi3hP4RrTENiY/AvN82n/S44+iEqYaPvULsrJ9dxTtrbC/XbDwJFSvm5WCy2qF6i
         0OIdfwcoq7wp6CwHFi6W5FtXCOO4Glo8XLi1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbDNBydaewl5dltimDBqmtpJAJq+VfTZXoANK7KfgaM=;
        b=YG0IrSwZ+8QX63DLbQaHdUvql3h5JaW/2ywt/xJYra9ngW80GA7IcP0dlzDgn7S5V3
         ld0dpv3mzTzV7d4YHayTADqY6PDIxtXjrVOQDA5nMjOYcO+Dfp5GduH013+xMxFkjoLe
         YjzDtzTb79cnaWMTkvCguhDSqEVnF+8eLey+9NG5uxKtxtjV4rSdl/IuFsQyHh9N5apj
         TK4ufze6myhnQvpqDgvk8kMB6aPXXWYlHbfVaCUVOFIu8QdOUPhs598trfV0cq2QwtSz
         JHw4nyIdVwc1aP9JcGPhq7Y3geQIDTJEMhPcTyxPj14uJXAcWoJ3jZjr2jqs5UEp1cU+
         qaNA==
X-Gm-Message-State: ANoB5pk68XpTjqtA+3fFtmFU7FL3Foz4+tw26i0pJ49y3nd2XkmeYnhA
        SqdT1tmc4cShHL5CHsuUAs0Qe+3NhekH1KDPlK8=
X-Google-Smtp-Source: AA0mqf7lyTOeHammBmxyAv6SxvTG7JRktqKBwLD3T2vtKC6j3rsl4QUM8GYAHH5/zlBN19IR9Q0qVw==
X-Received: by 2002:a62:3103:0:b0:576:14a4:b76a with SMTP id x3-20020a623103000000b0057614a4b76amr22376280pfx.34.1671035944998;
        Wed, 14 Dec 2022 08:39:04 -0800 (PST)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com. [209.85.214.178])
        by smtp.gmail.com with ESMTPSA id r11-20020aa79ecb000000b00575f348aa3esm92850pfq.122.2022.12.14.08.39.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 08:39:04 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id x2so2586162plb.13
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 08:39:03 -0800 (PST)
X-Received: by 2002:a17:902:ce04:b0:174:af35:4b90 with SMTP id
 k4-20020a170902ce0400b00174af354b90mr79455890plg.8.1671035943448; Wed, 14 Dec
 2022 08:39:03 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v3-0-954efc752c9a@chromium.org>
 <Y5nEgDOXFNDPf8/Y@pendragon.ideasonboard.com> <CANiDSCvLjr6NK3pL9NpLap44Zcc22OEbyRANXq90dtG+udro4Q@mail.gmail.com>
 <Y5nP1RXbd7mCkmCD@pendragon.ideasonboard.com>
In-Reply-To: <Y5nP1RXbd7mCkmCD@pendragon.ideasonboard.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 14 Dec 2022 17:38:52 +0100
X-Gmail-Original-Message-ID: <CANiDSCsHR2DNPNRkDNELSJcUqUbtxwGY_Rie=3o0NUF+qzDr7g@mail.gmail.com>
Message-ID: <CANiDSCsHR2DNPNRkDNELSJcUqUbtxwGY_Rie=3o0NUF+qzDr7g@mail.gmail.com>
Subject: Re: [PATCH v3] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Max Staudt <mstaudt@google.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent

On Wed, 14 Dec 2022 at 14:30, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> > > Isn't this still racy ?
> >
> > Indeed...
> >
> > I could add a mutex just for flush_status
> >
> > what do you think?
>
> It may be possible to avoid that. I'm giving it a try.

Just sent a new version without lock...





-- 
Ricardo Ribalda
