Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0067F9C3
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 18:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjA1RKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 12:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjA1RKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 12:10:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB4824CAD
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 09:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674925807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=HIRSOZVh//gsInC5jS540d1d6Q+sO5WiOYvg9x5Ssl8=;
        b=hxun+bpY+qGljgxrKlip1yJLEQhewxr3/DpaEpCbUh1xxv7nsFycEd7/QjO/CCRPGQelF6
        kLo0nsnVf/spDrVSut3FZkhmR045MC1PIgpeABMAkVr9ZWQVccy+GF/cVrjO5T1WzwA+po
        MNTnwVOS+sf4NYR/OGjEbsu3OAhJRlc=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-76-HbuGoRWXMZyK9watkSq92A-1; Sat, 28 Jan 2023 12:10:06 -0500
X-MC-Unique: HbuGoRWXMZyK9watkSq92A-1
Received: by mail-yb1-f198.google.com with SMTP id k15-20020a5b0a0f000000b007eba3f8e3baso8638953ybq.4
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 09:10:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HIRSOZVh//gsInC5jS540d1d6Q+sO5WiOYvg9x5Ssl8=;
        b=0swPZSg+CfWexT5ZyNPxVs/bB/QZKakqwpOpMRB7Ss0LxAPq3vkYuQ6LDpkY9eYWRO
         MV81YWYlDZ8LDdynZI8BFIzhOOmnbMc0UQ4yfXQhzrv37eKN3mQY0/thw/ctk2KJo5pB
         2p89EfkhaK0zXMqmzTKdbk2SGzIvd96i2QB9J3afjJF1brdTENnOsXDSR86YnZjc+S0F
         9pmepqcDhlVgYZJe4fDaitjKrmkgpyUBh520qlK+0RxQdQlS69Jz3AjTtlveEVtLFz9u
         OnLwMXTypwztpeFhvu4/O1XhuA8shpWMzpegvwkgzuiIWcC/E03auVXHbfhmDD+XiYP3
         Jg6Q==
X-Gm-Message-State: AO0yUKVbNuL9b7FFBQcUF3tSBpwXEEVB0feXsQJaoDhnqIdcjAIQKPze
        EmqZ27HYdiyvkf5Y8risVyanYQovPYak84LYt7s0aZ6uaPiv+XqNAgIo0dk0qWDnZL3enQpQrT4
        9OcuJriyTP+z4ydLJBDi3bjuuf51FQYbj
X-Received: by 2002:a81:9a55:0:b0:509:bd6:4d4b with SMTP id r82-20020a819a55000000b005090bd64d4bmr964491ywg.282.1674925805755;
        Sat, 28 Jan 2023 09:10:05 -0800 (PST)
X-Google-Smtp-Source: AK7set/Ti2FW7plMNR419sOkWM8O61U20pvs2B2S2qscenkXti1FnKmTt5RWb12r2oix5/26lKno9SC2kj72byBRtiM=
X-Received: by 2002:a81:9a55:0:b0:509:bd6:4d4b with SMTP id
 r82-20020a819a55000000b005090bd64d4bmr964490ywg.282.1674925805580; Sat, 28
 Jan 2023 09:10:05 -0800 (PST)
MIME-Version: 1.0
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Sat, 28 Jan 2023 12:09:54 -0500
Message-ID: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     gregkh@linuxfoundation.org
Cc:     casaxa@gmail.com, cezary.rojewski@intel.com, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org
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

I did a bisect which implicated
f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 as the first bad commit.

Reverting this commit on 6.1.8 gives me working sound again.

I'm not clear why this is breaking 6.1.x since it appears to be in
6.0.18 (7494e2e6c55e), which was the last working package in Fedora
for the 6.0 line. Maybe something else didn't make it into 6.1?

