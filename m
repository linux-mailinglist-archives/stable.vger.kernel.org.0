Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB242C09E
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 14:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhJMMzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 08:55:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231294AbhJMMy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 08:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634129576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EDsOoxW6EgtFgX4OT23FEb36jHTKMtrgphgk3Epw6BM=;
        b=hVzF7Mh5jkCtlLbWbDaRipBOF2GCmF7lCWEGXU7zXWp5HMnTd7P/f+Louwva1XForHs6YM
        W0yfEXxQ9DcA5sJN1+zIzpGrlHwWhZOvJDjdU+9vNwef5IdToSX4te45NW2nAAJzHnBeDd
        2ZNZdBImfVNA+scUlvkezkmx51fXsvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-_kjdl3s9NGCosEq6_R0ySg-1; Wed, 13 Oct 2021 08:52:52 -0400
X-MC-Unique: _kjdl3s9NGCosEq6_R0ySg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0C7F19200C4;
        Wed, 13 Oct 2021 12:52:49 +0000 (UTC)
Received: from localhost (unknown [10.39.193.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6286C5DA60;
        Wed, 13 Oct 2021 12:52:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        markver@us.ibm.com, linux-s390@vger.kernel.org,
        stefanha@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-devel@nongnu.org
Subject: Re: [PATCH v3 1/1] virtio: write back F_VERSION_1 before validate
In-Reply-To: <20211013081836-mutt-send-email-mst@kernel.org>
Organization: Red Hat GmbH
References: <20211011053921.1198936-1-pasic@linux.ibm.com>
 <20211013060923-mutt-send-email-mst@kernel.org>
 <96561e29-e0d6-9a4d-3657-999bad59914e@de.ibm.com>
 <20211013081836-mutt-send-email-mst@kernel.org>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 13 Oct 2021 14:52:38 +0200
Message-ID: <87zgrdulwp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13 2021, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Oct 13, 2021 at 01:23:50PM +0200, Christian Borntraeger wrote:
>> Can we get this kernel patch queued for 5.15 and stable without waiting for the QEMU patch
>> as we have a regression with 4.14?
>
> Probably. Still trying to decide between this and plain revert for 5.15
> and back. Maybe both?

Probably better queue this one, in case we have some undiscovered
problems with the config space access in virtio-net?

