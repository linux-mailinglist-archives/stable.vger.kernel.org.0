Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8555F21ED9F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 12:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGNKFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 06:05:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726041AbgGNKFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 06:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594721149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=M45goFW1k5rIsSg3jlh/sipfJG5akY3mkAx0YcJf4D0=;
        b=OKSOid7HgU+uUpCGm8ALlR1ONHgZtMJVf+1DvSyk7UO5Z5s26VnZCasGdN6EqSI3Q0ygfM
        +aqrWR2rCUz0kVeayOG+KF9OSq0S1rjNgdJy4r0zF9tSpePaNZJX6kz4Y+kbqB1wPpL2ly
        mBpegFBb3BgtrW+GXGFrCrGwyjaQ7w4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-zClGB2zFPJWrl9ataRcXhA-1; Tue, 14 Jul 2020 05:58:38 -0400
X-MC-Unique: zClGB2zFPJWrl9ataRcXhA-1
Received: by mail-wm1-f69.google.com with SMTP id g138so3148583wme.7
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 02:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=M45goFW1k5rIsSg3jlh/sipfJG5akY3mkAx0YcJf4D0=;
        b=Zek3dZgW+W3WkNZKtT98XWH75ovgYgjKUOB67W6mdLkCzloZJP+brlQPuiB5I61IgG
         Bq5fLuRkGRCZSSce6v2uK1/SDP0df0gNKgC1xR6g5RwVx+bx5HjZA/8USF6mLH46lxiR
         JTw3VNhSSQqE8ZbVnM2am3n4fhIcJ13/nsykB9ZBXPp5Q4geBMRjSCYwOtK9+4LCoC6L
         0MOIB+A5JjJgcrMjkjAlsqL36J9PD9Z67scREgabaXna0Maal6yhbza04s98AizMTZ9/
         OYGuxYJHkV5TKpx/TA5BWSc4Dk5H92biRqZOa1t/B8JmtkbGN8311X8MpsD7CUcmJj28
         afYA==
X-Gm-Message-State: AOAM532eO5n9Ab3LTbif9zHM3T3IHWXmzvJOEFLfJOpTnm2ou44aDDcX
        gS4fMiEV/6aSPTDxfau1BT/T8XPnQt0aYHjNpXpuqGlaVysVSOcihvD92FKlXqQOYDMRv9xjKHv
        +oD/nkUwVoVLy/WGY
X-Received: by 2002:a05:600c:2219:: with SMTP id z25mr3687752wml.154.1594720717629;
        Tue, 14 Jul 2020 02:58:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAqljQrA/da0BJJwYmv3rWaQ1K36YlvNOU+bBrZAudP7H3iMf7Q+UgFjgeqAMWypbGKPUFqg==
X-Received: by 2002:a05:600c:2219:: with SMTP id z25mr3687740wml.154.1594720717450;
        Tue, 14 Jul 2020 02:58:37 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id j24sm29419847wrd.43.2020.07.14.02.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 02:58:36 -0700 (PDT)
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Please revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb" from all stable kernels
Message-ID: <2a5acaae-9aef-1aab-d385-0dd11d151fa6@redhat.com>
Date:   Tue, 14 Jul 2020 11:58:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg (et all),

Note several people are already working on this, so you may already have a request for this.

The "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb" commit which has been
added to several stable kernels (at least to 5.4.y and 5.7.y, but likely also to others)
is breaking networking for people with an ath9k card.

A revert has been submitted upstream, but it does not seem to have found it way
upstream yet. It has been cherry-picked by the Arch people:

https://git.archlinux.org/linux.git/commit/?h=v5.7.8-arch1&id=1a32e7b57b0b37cab6845093920b4d1ff94d3bf4

So if you want to credit some of the original people working on fixing this,
you can find the revert submitted upstream there.

Reverting this fixes / also see:

https://bugzilla.kernel.org/show_bug.cgi?id=208251
https://bugzilla.redhat.com/show_bug.cgi?id=1848631

Regards,

Hans

