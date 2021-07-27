Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2493D7A15
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhG0PqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhG0PqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 11:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627400778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qyu2Y2TRrxflVv9Re1ddIxikd/FHNJ3gk/I5zZBEQ38=;
        b=SM8QrXZnA7pfNZsk7p8Q3noon5m0fpUiFdVsuC+DuGtGIwpbCf9VLU1tdn1OdandxUUYA7
        Dp2MjhLsWjuF7S+FndZwi2C8yO67XInqr7cZk5/vdK1uJUP6hCL8l4IYXGqaa52fLaXWeB
        I+/VJyaBuckVEp2Lx08KvRT500QXbVU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-5IYizjLgPparD42nJH1bhw-1; Tue, 27 Jul 2021 11:46:15 -0400
X-MC-Unique: 5IYizjLgPparD42nJH1bhw-1
Received: by mail-qk1-f197.google.com with SMTP id p123-20020a378d810000b02903ad5730c883so11821737qkd.22
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qyu2Y2TRrxflVv9Re1ddIxikd/FHNJ3gk/I5zZBEQ38=;
        b=XlbnPXUTvZe0L2+6VguFz9vozWpL+4Z3+fnxU20kSNQcxT3Om9x0Z52+git1j7pRh+
         uvE4rDq3DMOoLHVOqFshzPTy9MF1Gyjs9/1NLVq8kdp8XP6FD8G38ykZnQPh3sLy17O6
         ENbLugPeHQSYXXQpBr8meLluCqYjW9a9VJUNgvrYX6XI8CfEJOK8MEimwC0naFhiiSWy
         S9Xy+EOtgVoJI8fgosdOEVMjSUpsgVWYhssZKf/377Y4g/tfYL7g8vE7oKoenb/E4Sff
         DLmpY3uA1zWCVpOZmj9KNAq4zj8Vajvc4lK4KJbt43mM5zEflu1bwnfr4s4rbVwKCzDE
         i5oA==
X-Gm-Message-State: AOAM533kW6JmUyTeR2VRWj92qnZtZ+a9ACj899r2VEjpkv7Ke6a5n/+0
        dB60b1EdFbblw0Pl+SSOOL8xAUHQY/CxzHygJRuky6vmZVxQs1Z7U7ABY1pFiyvWgjLZ3dea3Cn
        CyT3gGYEpFBmm7Llw
X-Received: by 2002:a05:620a:1137:: with SMTP id p23mr23880576qkk.490.1627400775131;
        Tue, 27 Jul 2021 08:46:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhTawW9W+VTgqHYhIOqH2k2b/KQYhF35BYDKPB7IDZDwwML1ltc1GzD2gc42Ak+yJCkznYwA==
X-Received: by 2002:a05:620a:1137:: with SMTP id p23mr23880554qkk.490.1627400774782;
        Tue, 27 Jul 2021 08:46:14 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id f3sm1570573qti.65.2021.07.27.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:46:13 -0700 (PDT)
Date:   Tue, 27 Jul 2021 11:46:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: add missing compat KVM_CLEAR_DIRTY_LOG
Message-ID: <YQAqRB7OPHHQNdJ+@t490s>
References: <20210727124901.1466039-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210727124901.1466039-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 08:49:01AM -0400, Paolo Bonzini wrote:
> The arguments to the KVM_CLEAR_DIRTY_LOG ioctl include a pointer,
> therefore it needs a compat ioctl implementation.  Otherwise,
> 32-bit userspace fails to invoke it on 64-bit kernels; for x86
> it might work fine by chance if the padding is zero, but not
> on big-endian architectures.
> 
> Reported-by: Thomas Sattler
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

