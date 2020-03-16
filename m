Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41F2186BFF
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgCPN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:27:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25797 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731234AbgCPN1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584365220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAa8W1GpKOFQ9uH0rIF24BEsTUyJ4zjIcHo9qBXCBn8=;
        b=N52bKd6vZGrJD53mqpX7uW3L/Z5P4urlbRCtXy72+IvhQQO2MoufNrSEHq8SeGLrNN6NAX
        U4gx/kcEHvYXBFos1i/LoQjSH/o8UkpBNyTigzWRqwe/5Vu7flLqFVptPIzA/Y9rDWJbzY
        GaxaLR4z5STRTcHI8CmtbOmt/AcE/Mo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-OzG0T2PtObuTgRdCOFW1dQ-1; Mon, 16 Mar 2020 09:26:58 -0400
X-MC-Unique: OzG0T2PtObuTgRdCOFW1dQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBA09800D5A;
        Mon, 16 Mar 2020 13:26:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E385E91D8C;
        Mon, 16 Mar 2020 13:26:56 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D709686A37;
        Mon, 16 Mar 2020 13:26:56 +0000 (UTC)
Date:   Mon, 16 Mar 2020 09:26:56 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     ardb@kernel.org, mingo@kernel.org, stable@vger.kernel.org
Message-ID: <1928257716.16051328.1584365216796.JavaMail.zimbra@redhat.com>
In-Reply-To: <15843634466260@kroah.com>
References: <15843634466260@kroah.com>
Subject: Re: FAILED: patch "[PATCH] efi: Add a sanity check to
 efivar_store_raw()" failed to apply to 4.19-stable tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.205.4, 10.4.195.7]
Thread-Topic: FAILED: patch "[PATCH] efi: Add a sanity check to efivar_store_raw()" failed to apply to 4.19-stable tree
Thread-Index: VM2gPR98/MxHRUCq4l58EirQNLPGUw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

----- Original Message -----
> From: gregkh@linuxfoundation.org
> Subject: FAILED: patch "[PATCH] efi: Add a sanity check to efivar_store_raw()" failed to apply to 4.19-stable tree
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backported to 4.19/4.14/4.9/4.4-stable:

https://lore.kernel.org/stable/20200316131938.31453-1-vdronov@redhat.com/T/#u
 
> thanks,
>
> greg k-h

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

