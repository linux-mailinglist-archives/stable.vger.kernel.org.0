Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023DE68BE40
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBFNcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 08:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjBFNcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 08:32:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC20D24132
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 05:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675690270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPpoCAzy3QGdRF5CjYYrnG2pjs3nd8X+mOalE/GKH1k=;
        b=SBbjJImGFlDCz/Yi8oYT8OjP2Ri/oAy6zLm8EVp22TV1ZHHnZbqerSMHgsTK2gJuSMyyr7
        7TempOeVFzvjtWplPysDkX2KWfpsZWrIU0wjShTKHHL7RaOWkAZ/07xz1Wv+OkRnvfLX5e
        5cN2hdF67oPxOAAOsMLv7N1naEGJy4s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-wkXYcvevOO-JkyuVoZzCPA-1; Mon, 06 Feb 2023 08:31:04 -0500
X-MC-Unique: wkXYcvevOO-JkyuVoZzCPA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C73B81C05147;
        Mon,  6 Feb 2023 13:31:03 +0000 (UTC)
Received: from plouf.local (ovpn-192-160.brq.redhat.com [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5B88492B21;
        Mon,  6 Feb 2023 13:31:01 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        "Peter F . Patel-Schneider" <pfpschneider@gmail.com>,
        =?utf-8?q?Filipe_La=C3=ADns?= <lains@riseup.net>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Tobias Klausmann <klausman@schwarzvogel.de>,
        stable@vger.kernel.org
In-Reply-To: <20230203101800.139380-1-hadess@hadess.net>
References: <20230203101800.139380-1-hadess@hadess.net>
Subject: Re: [PATCH] HID: logitech: Disable hi-res scrolling on USB
Message-Id: <167569026165.2830974.5581534197133188329.b4-ty@redhat.com>
Date:   Mon, 06 Feb 2023 14:31:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 03 Feb 2023 11:18:00 +0100, Bastien Nocera wrote:
> On some Logitech mice, such as the G903, and possibly the G403, the HID
> events are generated on a different interface to the HID++ one.
> 
> If we enable hi-res through the HID++ interface, the HID interface
> wouldn't know anything about it, and handle the events as if they were
> regular scroll events, making the mouse unusable.
> 
> [...]

Applied to hid/hid.git (for-6.2/upstream-fixes), thanks!

[1/1] HID: logitech: Disable hi-res scrolling on USB
      https://git.kernel.org/hid/hid/c/690eb7dec72a

Cheers,
-- 
Benjamin Tissoires <benjamin.tissoires@redhat.com>

