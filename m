Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BA0309D4
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 10:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfEaIGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 04:06:18 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33281 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfEaIGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 04:06:18 -0400
Received: by mail-pf1-f181.google.com with SMTP id x10so604049pfi.0
        for <stable@vger.kernel.org>; Fri, 31 May 2019 01:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=os3L1aVX5urKdl/cFtZ58c7IF2+Q+k6ccfeuAVisz7U=;
        b=axdYRrIlGG8i4TJ34DvLRWKhQVMKYg5PQrJhvoDkY8NxJ6WWVvkrFTJ0Q1i6duljo7
         /bLvUxma1BwaPI8qj3hCgq9m/wp2gLSbF++38PlpKd0a6veaquuaMvJTJwbxc15eR+gI
         D9WM9vaoakfJYQvrPD9HbvRqBZ2Dzs82OvAeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=os3L1aVX5urKdl/cFtZ58c7IF2+Q+k6ccfeuAVisz7U=;
        b=fDLqc/kZYWX1Cq8xYnTEgtaCPcxDPGtDbw0VQlwOEffOF/WAy9TCzP+RZ/un7axvfE
         AE7DX6iJU0oxKu4yQhZUjZ/iE37MuRbEPvB7P08d9dxFZsfEN4rp4h35yBXTx+ikhT2o
         YtP6Z4F1KzD+N1gZAuxs+J5qOa8Eyn4UR5tcuGv9xsFaHYQJkKGXx5CIEV9Ef4XB8rkw
         CgWY40sWmG9NVObZPYrj47AfAZcSV1OnuSs3rrr+jtTPGywY9TZVsu2g4rtDBddC+JTq
         4kh4tLiXnHRbCCTf0IKvd+b+e8VyYnpwnJM+Ynpi2EHWvm0UfDJqRLG3/9pug+elI+Wf
         RnLA==
X-Gm-Message-State: APjAAAVQ0+v0zwjEcXwXYZyxznq6CKPAZ9WU03cqgDczukXEL+8NNrjd
        4yYSt0FX6v9JG5nj3OShHpqtpA==
X-Google-Smtp-Source: APXvYqzVO29kuep0HFj1p9Lz+mholj8I0J4ZCtAVHKOa+CsJ2PZnmDqnMec95dTKrHcsBufJEgKOyA==
X-Received: by 2002:a63:2b92:: with SMTP id r140mr7630955pgr.363.1559289977336;
        Fri, 31 May 2019 01:06:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 132sm4705007pga.79.2019.05.31.01.06.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 01:06:16 -0700 (PDT)
Date:   Fri, 31 May 2019 01:06:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yaro Slav <yaro330@gmail.com>, stable@vger.kernel.org
Subject: pstore backports to 4.14
Message-ID: <201905310055.F37C37E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Can you please add these two pstore fixes to 4.14 please? They are
prerequisites for another fix I'll be sending to Linus soon that'll
be needed in 4.14 (to fix the bug Yaro ran into).

b77fa617a2ff ("pstore: Remove needless lock during console writes")
ea84b580b955 ("pstore: Convert buf_lock to semaphore")

Thanks!

-- 
Kees Cook
