Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A9C112DAB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 15:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfLDOnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 09:43:14 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727944AbfLDOnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 09:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575470593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3VYZu2Msuo/GrqTGe5D8EVEkLes+Ylvr+P670WnJo0=;
        b=DBOhUV7Ye1ODezRCtpMBZdxHd/vC/chLRPaY5FCiu1kMzdxME1h888c8UR/toN/lIQgRZe
        GNR/zGpFLH5fhqikzKLrd50pGEDs/QAKW3Y6XiIdBTfq41iYJEY7H4rqQrINZNEDlqZ6ko
        9n39X+RihZh93NgwxLoqCyiD00fPaho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-JNulPZWVPeum3MOUKv5umw-1; Wed, 04 Dec 2019 09:43:09 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB77818543A6;
        Wed,  4 Dec 2019 14:43:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 869F65D6AE;
        Wed,  4 Dec 2019 14:43:07 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E20315BC09;
        Wed,  4 Dec 2019 14:43:04 +0000 (UTC)
Date:   Wed, 4 Dec 2019 09:43:04 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        darrick wong <darrick.wong@oracle.com>,
        linuxppc-dev@lists.ozlabs.org,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Message-ID: <385099805.15030947.1575470584839.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191203190925.GA5150@infradead.org>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com> <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com> <8736e3ffen.fsf@mpe.ellerman.id.au> <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com> <1766807082.14812757.1575377439007.JavaMail.zimbra@redhat.com> <20191203190925.GA5150@infradead.org>
Subject: Re: [bug] userspace hitting sporadic SIGBUS on xfs (Power9,
 ppc64le), v4.19 and later
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.3]
Thread-Topic: userspace hitting sporadic SIGBUS on xfs (Power9, ppc64le), v4.19 and later
Thread-Index: bZFnIYc4/9CmmxXsANYOsGnjcI2iPQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: JNulPZWVPeum3MOUKv5umw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> Please try the patch below:

I ran reproducer for 18 hours on 2 systems were it previously reproduced,
there were no crashes / SIGBUS.

