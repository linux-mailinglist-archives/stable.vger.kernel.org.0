Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D526CE1A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 23:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgIPVJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 17:09:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgIPPza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 11:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600271703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=0ihSz/TjOZxVz9JDvtQ46oStCiPqdu2mGppTecxTUUM=;
        b=K9N4QK0iArcm481EIqEzo9O6A+1V249XzpJADwtWvk8i4Vfab4nkX2Gl34xH9EbekDK3d7
        3fC5sWcgw5Ake5LNKGj833c1q2fPmpPOfpBmAp2ofoDDDzSPk7CmxY9PChYwM+/pEbJzq1
        OwwXw9b9PQ5lrIdhJj9oXYZCd1DlEKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-fMJJq_5jNwmk5p65JFSOiQ-1; Wed, 16 Sep 2020 11:37:59 -0400
X-MC-Unique: fMJJq_5jNwmk5p65JFSOiQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D64C1017DFE;
        Wed, 16 Sep 2020 15:37:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 743A358;
        Wed, 16 Sep 2020 15:37:58 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3ABE044A64;
        Wed, 16 Sep 2020 15:37:58 +0000 (UTC)
Date:   Wed, 16 Sep 2020 11:37:57 -0400 (EDT)
From:   Yi Zhang <yi.zhang@redhat.com>
To:     stable@vger.kernel.org
Cc:     chaitanya.kulkarni@wdc.com, sagi@grimberg.me, sashal@kernel.org,
        gregkh@linuxfoundation.org
Message-ID: <1955465429.1342553.1600270677594.JavaMail.zimbra@redhat.com>
In-Reply-To: <16579579.1342431.1600270596173.JavaMail.zimbra@redhat.com>
Subject: Please apply commit "64d452b3560b nvme-loop: set ctrl state
 connecting after init" to 5.8.9+
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.41, 10.4.195.20]
Thread-Topic: Please apply commit "64d452b3560b nvme-loop: set ctrl state connecting after init" to 5.8.9+
Thread-Index: 6ST8piDhlGpC8jnHa4NqqfbzRLbi4g==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please apply [1] to stable 5.8.9+, as it fixed nvme-loop connecting failure issue[2].

[1]
64d452b3560b nvme-loop: set ctrl state connecting after init

[2]
https://lists.linaro.org/pipermail/linux-stable-mirror/2020-September/216482.html


Best Regards,
  Yi Zhang


