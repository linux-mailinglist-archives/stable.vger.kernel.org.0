Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37056665FC7
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 16:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjAKPxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 10:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbjAKPx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 10:53:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D742AC7
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 07:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673452354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ryrrVULoscZ1riSGOM9SabdXBEw/UV56TVFRHhdk8Hk=;
        b=OeG/wFkoFBUl7kBMrY3aX6Q7SHhR2FsIkPoFWljbStLgdBSGkYfQK/1Wb2RGYLOlqDf3cB
        TcFL+f7PdeMRZAVErvKIiI51T+AtMUnou2ugOgp+7JrErtFNg7X/UEl5lUs0TMwHJlwkhC
        7lHsgvHkvb5/zWJfTCdEyL0UClTMjdU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-dQc5b7NQPHOw86vBgBYiaA-1; Wed, 11 Jan 2023 10:52:33 -0500
X-MC-Unique: dQc5b7NQPHOw86vBgBYiaA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-4ad7a1bd6f4so167436207b3.21
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 07:52:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ryrrVULoscZ1riSGOM9SabdXBEw/UV56TVFRHhdk8Hk=;
        b=7WY8kvCo3ve7BawtxCuM+Ipf6pmH53oUQzHX892mVgnxje4hemzMXmLDviq8WUKMn3
         1Jb4AeU76P8BHWLm5K5Enfg2hBZ1TvbKRDLAi9Slht7TSO/J2E2kx2+gn9ib+sqM8CLi
         C95EhGNNMaFh8rNgaSGd7e/pBqn0Kx3/JLk9aF3i0QaXm/nCs3UVQz8XebhCXg0vyqdK
         t+CCXIY9mmweLaIrHzsqQjDgyKkj/c5iny9vBkCNSobr6UxoxBKtZaORmA9pbxwEiilc
         fQ7JhBb247twEMp0YNLu1azfEGvaxMj3HB+sA4hEMQ7VXD/L+LxGTXmTyyfSmTU29V8M
         tqZg==
X-Gm-Message-State: AFqh2kpChXpaXF3XWwp/7txxq1rOkyBVOI5x0/hrLBpnhNbXw7STzrfL
        Dk5a4yOItIs2hM8HGO2rIdYRRweJdVQqsULVCUNPjC1Hc3xvM2EPZNYV4Q2jYiUN2QNk+e1HQTy
        +X+i7wMu/+B5kTs/TqKsL8v1JzEH7ISJj
X-Received: by 2002:a05:690c:fd5:b0:4a4:7135:9214 with SMTP id dg21-20020a05690c0fd500b004a471359214mr6355351ywb.378.1673452352788;
        Wed, 11 Jan 2023 07:52:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtStWXR+38RfXxzFTVMcf7hzA0i9hXKSpLyfi0CZB2+pYusTRUJDWvXhu+YWgsAtexBs1T/Ku+QZ43JZuHtbu8=
X-Received: by 2002:a05:690c:fd5:b0:4a4:7135:9214 with SMTP id
 dg21-20020a05690c0fd500b004a471359214mr6355349ywb.378.1673452352610; Wed, 11
 Jan 2023 07:52:32 -0800 (PST)
MIME-Version: 1.0
From:   Paul Holzinger <pholzing@redhat.com>
Date:   Wed, 11 Jan 2023 16:52:21 +0100
Message-ID: <CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com>
Subject: [Regression] 6.0.16-6.0.18 kernel no longer return EADDRINUSE from bind
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Since updating to 6.0.16 the bind() system call no longer fails with
EADDRINUSE when the address is already in use.
Instead bind() returns 1 in such a case, which is not a valid return
value for this system call.

It works with the 6.0.15 kernel and earlier, 6.1.4 and 6.2-rc3 also
seem to work.

Fedora bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2159066

To reproduce you can just run `ncat -l 5000` two times, the second one
should fail. However it just uses a random port instead.

As far as I can tell this problem is caused by
https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
which did not backport commit 7a7160edf1bf properly.
The line `int ret = -EADDRINUSE, port = snum, l3mdev;` is missing in
net/ipv4/inet_connection_sock.c.
This is the working 6.1 patch:
https://lore.kernel.org/all/20221228144339.969733443@linuxfoundation.org/

Best regards,
Paul

