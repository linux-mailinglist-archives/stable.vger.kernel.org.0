Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321E36C19F9
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjCTPki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbjCTPkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:40:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1FB86AF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:31:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w9so48366196edc.3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1679326314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONCoqAuPFAdxcHJlJkmwpKMX/MPlR6FkYHZLYnTGWGA=;
        b=ZAG07fjd1pGdKzK6v1r6GnVVdTiwCGVdbZgvimV0oMBbMrtpEp7Vf5VtfChYznrOc6
         H0M5oKF/oqkK+eiujHnj4RkGkHe1EGUWGTj5spGvroIRSc0RunHN0DZeywnFEy+ELW3g
         I1IsObzaSbYO7aYSdtbhiiuZyLfr04luFU8Ju/hnMT9QRQjo3bnL3xU12gKF8bXKVocG
         wPSKeMuXRncMIA08YpSBxkh35gUR42GYCP/ZSehhvMNiZVSOhSd24vgR4AsLaeCwcD26
         mQChHP13oK+HLvVovVvuVvI/Re5PiAqBU2KoYz0eW9Tb3NAQLfevbE9pwLetC1J9bp4O
         FRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679326314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONCoqAuPFAdxcHJlJkmwpKMX/MPlR6FkYHZLYnTGWGA=;
        b=iA8OXGiiHCWAjQnN+2EZqCH9JxnCbuqWI7Qz/u6WPLXhpXQQLRN/j/150o3kzTG+bZ
         Q7GGwpOh4DK/Z56m7mLVdBsUJXwHhLdDdVJM6vMFv1rYrmY3MSOni0KAFpeV6+8h8Ufq
         hYZ3aPZh1csdMnPzFvIQHljv/swTgMDySNWOjif7+LtKkhmW54cPl0UCx56bPp/MBqFA
         V3NbMmDs7x2DR16NmpLneHPbxNSgmBm+XuqAeonVT29TFkMXCwIZxYeX+NUyOIW4RJJM
         23gha5B3CCLBSQx5/wsW3B1/0YliFSSymEFRJWshcno3ZVFrVMGQNchSGzr+wHhJ/7HD
         w2dQ==
X-Gm-Message-State: AO0yUKX6+tNTxnut8FFNX7pGlYCdQqBZasMljXW/0k/rukHAE/nGmTcU
        0nhAeiSUirSowZv/IUibJhdmmC3LXGSjGlbACYMEAA==
X-Google-Smtp-Source: AK7set9zRda+HOBbyE1RH7U3Q5LdXAIFkGANo3ucDxxjiF5CtJ+awwn6fl76qqAqukfOF4oE95J6aFnk+XfPYhz4GPU=
X-Received: by 2002:a17:906:cf8d:b0:930:310:abef with SMTP id
 um13-20020a170906cf8d00b009300310abefmr4344539ejb.3.1679326313919; Mon, 20
 Mar 2023 08:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230320005258.1428043-1-sashal@kernel.org> <20230320005258.1428043-8-sashal@kernel.org>
In-Reply-To: <20230320005258.1428043-8-sashal@kernel.org>
From:   Lorenz Bauer <lmb@isovalent.com>
Date:   Mon, 20 Mar 2023 15:31:42 +0000
Message-ID: <CAN+4W8g6AcQQWe7rrBVOFYoqeQA-1VbUP_W7DPS3q0k-czOLfg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 08/30] selftests/bpf: check that modifier
 resolves after pointer
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, shuah@kernel.org,
        yhs@fb.com, eddyz87@gmail.com, sdf@google.com, error27@gmail.com,
        iii@linux.ibm.com, memxor@gmail.com, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 12:53=E2=80=AFAM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> From: Lorenz Bauer <lorenz.bauer@isovalent.com>
>
> [ Upstream commit dfdd608c3b365f0fd49d7e13911ebcde06b9865b ]
>
> Add a regression test that ensures that a VAR pointing at a
> modifier which follows a PTR (or STRUCT or ARRAY) is resolved
> correctly by the datasec validator.
>
> Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
> Link: https://lore.kernel.org/r/20230306112138.155352-3-lmb@isovalent.com
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Sasha,

Can you explain why this patch was selected? I'd prefer to not
backport the test, since it frequently leads to breakage when trying
to build selftests/bpf on stable kernels.

Thanks
Lorenz
