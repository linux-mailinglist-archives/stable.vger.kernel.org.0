Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D66661ED2
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 07:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbjAIGrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 01:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbjAIGq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 01:46:56 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AB41277F;
        Sun,  8 Jan 2023 22:46:45 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id o66so6359365oia.6;
        Sun, 08 Jan 2023 22:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWTbV+yGsvA8MBDY5TTHHvW+0/kKWX4faTPXXd/fHBQ=;
        b=YszkKnmi3TEMUnOeNfKS5EbBMeOhxLrzl+OL2IbMSphw+u1AhZvMAvKmn+sWUJoL6d
         oN8LG4N6hVx4p8nyGfkH53jtdbzsYKPhxTNQ+7awik1ZxMJo75wTRYS5HXoRu5x0aBxn
         rkOlJMc7EfOuOVBi+4hFvCBn79sL1EmErWShq4Js4ff3pa/DeQtgZWFBAT8YkyGwsyys
         QlLBwuYmxqFss2rk/cOmNmeetAA6zjffg96S081B8hDr1TVUQ6WfFXLFQxCkFuMjdRCm
         /lThBcqCz/ejL1jIs26YCixQt40DCSSmpnJKy+zMXfbpuHnAyCGy43BzDJzR4cfNMLMR
         jdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWTbV+yGsvA8MBDY5TTHHvW+0/kKWX4faTPXXd/fHBQ=;
        b=aswGnXdOvIic9sOMGCxXYobXOe6Tu0g5xaS7hltnJgv0qWmai2SnGzVlOc/WAPYDPO
         qH+dE1Z6YAfz2SOxn3nL3M8924TCKrm6zibHqSeNaPXlsjiuQ6+Twlhy2Ff7o/pG4eCW
         qVMf2uYIVeKOZ22Pq/7J8R3D2isX09bKPHJML0vOcaHTOaTJUZouGtaXlfW+0iih2Pce
         lrYHEjEwGnM036UokIUgNcXeZAFCHq5DNMD8H8TJNLYTj59yG02aoKfa0F14ZbewMm3j
         FPjxQCwF6ooWT6ieoOrlSHiZ2a6YmGmIQIzulM2yP3XV+hocz+BhI2xt7FuL7jkG9MGA
         QJLA==
X-Gm-Message-State: AFqh2krkH3OHY/NbJb2IwTyN/e35jbmhOgBYOpLF9wNziPM91D26zzHX
        McSXj3fXJ1HBTGUktMQOuTnjBkRj8rUogy+wYljKr0uM
X-Google-Smtp-Source: AMrXdXuKVvdVxAZAfMHf4mATZaHCmdYGIE4KwDwVwgoht3jLuvUFI44Wt5QBgkPBY178mNuAGSvNX3IB6NyGkG1s0zo=
X-Received: by 2002:a05:6808:8fb:b0:355:51ec:36c9 with SMTP id
 d27-20020a05680808fb00b0035551ec36c9mr3743519oic.245.1673246805176; Sun, 08
 Jan 2023 22:46:45 -0800 (PST)
MIME-Version: 1.0
References: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
 <Y5rsdo/SGHJM4UKG@kroah.com> <CADiBU3-iVLQf6Q5SzOB_pMCs2PGcFuWryjpDn5Qvz41WQ6C2RA@mail.gmail.com>
 <Y5sIZ3zC6o4ARDEn@kroah.com> <20230109014123.GA27423@linuxcarl2.richtek.com> <Y7u2Yi+UeqMcVhad@kroah.com>
In-Reply-To: <Y7u2Yi+UeqMcVhad@kroah.com>
From:   ChiYuan Huang <u0084500@gmail.com>
Date:   Mon, 9 Jan 2023 14:46:34 +0800
Message-ID: <CADiBU39yh9k=BWOmQ_-T3oO1nRQ6nHVjf4H+YRpjb3Mv_3tc0w@mail.gmail.com>
Subject: Re: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes
 sysfs create fail
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     ChiYuan Huang <cy_huang@richtek.com>, linux@roeck-us.net,
        heikki.krogerus@linux.intel.com, matthias.bgg@gmail.com,
        tommyyl.chen@mediatek.com, macpaul.lin@mediatek.com,
        gene_chen@richtek.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E6=96=BC 2023=E5=B9=B41=E6=9C=889=E6=
=97=A5 =E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=882:38=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Mon, Jan 09, 2023 at 09:41:23AM +0800, ChiYuan Huang wrote:
> > ************* Email Confidentiality Notice ********************
> >
> > The information contained in this e-mail message (including any attachm=
ents) may be confidential, proprietary, privileged, or otherwise exempt fro=
m disclosure under applicable laws. It is intended to be conveyed only to t=
he designated recipient(s). Any use, dissemination, distribution, printing,=
 retaining or copying of this e-mail (including its attachments) by uninten=
ded recipient(s) is strictly prohibited and may be unlawful. If you are not=
 an intended recipient of this e-mail, or believe that you have received th=
is e-mail in error, please notify the sender immediately (by replying to th=
is e-mail), delete any and all copies of this e-mail (including any attachm=
ents) from your system, and do not disclose the content of this e-mail to a=
ny other person. Thank you!
>
> Now deleted.
>
> For obvious reasons, this wording is not compatible with kernel
> development :(

I'm sorry about that. Let me check with MIS..............
