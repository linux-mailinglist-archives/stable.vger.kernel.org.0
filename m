Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CFC273EF2
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 11:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgIVJxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 05:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIVJxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 05:53:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3FEC061755;
        Tue, 22 Sep 2020 02:53:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so16304571wrn.13;
        Tue, 22 Sep 2020 02:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:references:date:in-reply-to
         :user-agent:mime-version;
        bh=6dBT2dqpLWNwfIVtTr97x8ZWf+SXjYzPHkyJeDHUMEE=;
        b=cO6YpJiolHAzZWZPzy2/ARKhpiVN+XV+e4IoDE9PjYOtrNfutT5jQh/NAx6G0Kc+zr
         1hx3kLSbut9pYYDoYeeS6r7ZBuBiDOvUuO7EDj/pgtaRF2xl0ZYsH8gHCIELcPMVxpCq
         PRRnu19V+NafFJUoWlWfu0Z6DSKMzYDNZl+BkKcPbuygYDCbE0HCtIw6VLeCP2ZSXSQR
         EYZHRJVKoOhEvf7czhH3FOyR9nbQpKe7wSiTPSjG/bWvuIKuebwzipngt45kD+LtDmpi
         lyh26stR2ZwXy2JuDWITyZ3UMJoBpQGUo6IZxeMXZLSZ3syyzJIC8HkwxaOZF2boujQN
         hWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:references:date
         :in-reply-to:user-agent:mime-version;
        bh=6dBT2dqpLWNwfIVtTr97x8ZWf+SXjYzPHkyJeDHUMEE=;
        b=RoBpiVpRLafO+A0A+U6eGDm9mmHjbMLa1SdtVC2c3UGYvn796m0OuD5+oAxqt2uZSj
         6l0rVjR1S0MQLTd97Tmu3KbTdMS7xgH3XEwFsKu6Rx4c2vTOxh0f3s3oONMTlPnbAr4J
         I7U+r4AOjxBZ7hywMk98F8/mlQBwE3O0KpkpQprVxSH73BeBSvLVOieaKjimAZ9Bhi0L
         SX7q74G9gf/HRCUxdCdKnQxPaJYKSH9K/lQzN8C9Q8tPXr87UB56bB6MrUEoxrrKflJm
         BPmX25wolt31FEQ6U9f0UECWxUAbJFSYOJ3g3MnrtAfYievH554/DR4Jdy63GXLRb0PE
         g4SQ==
X-Gm-Message-State: AOAM532YgSU6k0stVIaoqNQcK+XKd/6aQbxu33CNYeXFaBgRkU3FmtWA
        fP4RdYn2pfuQaWTztTml436vNlHEeO4jlw==
X-Google-Smtp-Source: ABdhPJze9NbuykH8o0aCwRaM4W3RembhFS1YOKxV5djnl6zg1bgkpSsSBSstQS+r8EdRyfC/fM5OVA==
X-Received: by 2002:adf:9027:: with SMTP id h36mr4336706wrh.259.1600768421749;
        Tue, 22 Sep 2020 02:53:41 -0700 (PDT)
Received: from daniel-ThinkPad-X230 ([2a01:e35:1387:1640:1853:cc4f:48fd:e3ca])
        by smtp.gmail.com with ESMTPSA id y1sm3721354wma.36.2020.09.22.02.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 02:53:40 -0700 (PDT)
Message-ID: <5f69c9a4.1c69fb81.b5b0d.9c89@mx.google.com>
X-Google-Original-Message-ID: <87v9g6p270.fsf@gmail.com>>
From:   <f1rmb.daniel@gmail.com> (<Daniel Caujolle-Bert>)
To:     Johan Hovold <johan@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] USB: cdc-acm: handle broken union descriptors
References: <20200921135951.24045-1-johan@kernel.org>
        <20200921135951.24045-3-johan@kernel.org>
Date:   Tue, 22 Sep 2020 11:53:39 +0200
In-Reply-To: <20200921135951.24045-3-johan@kernel.org> (Johan Hovold's message
        of "Mon, 21 Sep 2020 15:59:49 +0200")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
