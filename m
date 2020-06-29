Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2485920D426
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgF2TFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:05:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37568 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729342AbgF2TFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/J98WZe++cAbuLycqJ7pm5xPj75BR8RTuTI7IXu0XM=;
        b=hspRqAhRaBa1qIJfgJwoiFlEFriFig9HnZ9cohXsqDdYyAQK/IDggUsCaSSnjeWZk28C9/
        x74s1jIvszqlKqJH6iP6DLG2x8DGVXA1QPABHTBl2gzAo69tsA1nUej4ZBJx009yrSDVIb
        bHVFXAds0Wj/8lmy1P9BQy+1Jn/eARg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-0bo05DLwPleJF8c9UTOYTw-1; Mon, 29 Jun 2020 06:02:24 -0400
X-MC-Unique: 0bo05DLwPleJF8c9UTOYTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F881883614;
        Mon, 29 Jun 2020 10:02:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1BD85BAEC;
        Mon, 29 Jun 2020 10:02:23 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88EAC87871;
        Mon, 29 Jun 2020 10:02:23 +0000 (UTC)
Date:   Mon, 29 Jun 2020 06:02:23 -0400 (EDT)
From:   Yi Zhang <yi.zhang@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     chaitanya.kulkarni@wdc.com, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Message-ID: <1015661434.32401219.1593424943236.JavaMail.zimbra@redhat.com>
In-Reply-To: <1528690896.32343478.1593229315244.JavaMail.zimbra@redhat.com>
References: <1528690896.32343478.1593229315244.JavaMail.zimbra@redhat.com>
Subject: regression: blktests nvme/004 failed on linux-stable 5.7.y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.41, 10.4.195.12]
Thread-Topic: blktests nvme/004 failed on linux-stable 5.7.y
Thread-Index: 0H5pMP9dFmzDE4G+SBAO/Vn8Agfufx1WNgsy
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

commit[1] introduced regression that will lead blktest nvme/004 failed on v5.7.5, and commits [2] fixed this issue on latest linux tree.
But commit[2] cannot be directly applied to stable tree due to dependceny[3], could you help backport the fix and dependency to stable tree, thanks.


[1]
64f5e9cdd711 nvmet: fix memory leak when removing namespaces and controllers concurrently

[2]
819f7b88b48f nvmet: fail outstanding host posted AEN req

[3]
1cdf9f7670a7 nvmet: cleanups the loop in nvmet_async_events_process
696ece751366 nvmet: add async event tracing support


Best Regards,
  Yi Zhang

