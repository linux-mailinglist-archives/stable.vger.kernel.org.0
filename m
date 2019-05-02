Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7611939
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfEBMjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:39:17 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45781 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEBMjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 08:39:17 -0400
Received: by mail-oi1-f193.google.com with SMTP id t189so1450267oih.12
        for <stable@vger.kernel.org>; Thu, 02 May 2019 05:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TNPGVOvGnHQLUQt71NpMFgwVIQQk9jFktc8kenadxPs=;
        b=B3UgRcg6DCLlUSubTiQTDKau3SWcrZ/OzNDkV1uiDPldu3f2afsFiZd1ce6CmswVtW
         rwURKAJSH9VpAcx2GUdFWxajG/kbrmwPTj/F0U90S/9IQ8OJfXZV24de4grS4e4LI6MG
         L6XUIxXGYfssqGM5qdty9pLk/0XpbfT9OK2/W6o434/2RGbem3Ks0yLI0peyr3s+StU1
         +DRwUj8rPYVfx8ow2AZzm6EWMie5sQnxqH6yteToUCgPmkQMIIl+Dncz7g+5Kj56W1XG
         T/yq/2HGmAJaZ28ir7gUtNdZjdKwsCebaX3fTJE+QlAAjG3jSkOMyqpIhWFmchSWaZQ8
         BrHQ==
X-Gm-Message-State: APjAAAVzIj6xOYnu94dE95k1xtUfGqq1rPGRYnyyNPuV5nlojfHV7cfX
        UgW9e//CwteBJeFw4BZxRP6loejXpPA=
X-Google-Smtp-Source: APXvYqye955Y2d8Jj8LV4O4kStz2Dk8EBn3NjnhJa3Jb4yDAuBPrEEFMsNIiPSY30TK8fqjJ4m5kHA==
X-Received: by 2002:aca:4812:: with SMTP id v18mr963813oia.7.1556800755720;
        Thu, 02 May 2019 05:39:15 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id f17sm9065607oto.5.2019.05.02.05.39.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:39:15 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Stable_queue=3a_queue-5=2e0?=
To:     Stable <stable@vger.kernel.org>
References: <cki.9E62F0CA7D.Y9JIG3XX5K@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <48c70101-155e-a9cf-54b0-b7fbfa12a7b5@redhat.com>
Date:   Thu, 2 May 2019 07:39:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cki.9E62F0CA7D.Y9JIG3XX5K@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 5/2/19 7:32 AM, CKI Project wrote:
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: d5a2675b207d - Linux 5.0.11
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
> 
> We attempted to compile the kernel for multiple architectures, but the compile
> failed on one or more architectures:
> 
>            aarch64: FAILED (see build-aarch64.log.xz attachment)
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>              s390x: FAILED (see build-s390x.log.xz attachment)
>             x86_64: FAILED (see build-x86_64.log.xz attachment)

Here's the relevant error output from the builds:

> 00:00:56 kernel/trace/trace.c: In function 'buffer_pipe_buf_get':
> 00:00:56 kernel/trace/trace.c:6852:10: warning: 'return' with a value, in function returning void
> 00:00:56    return false;
> 00:00:56           ^~~~~
> 00:00:56 kernel/trace/trace.c:6846:13: note: declared here
> 00:00:56  static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
> 00:00:56              ^~~~~~~~~~~~~~~~~~~
> 00:00:56 kernel/trace/trace.c:6855:9: warning: 'return' with a value, in function returning void
> 00:00:56   return true;
> 00:00:56          ^~~~
> 00:00:56 kernel/trace/trace.c:6846:13: note: declared here
> 00:00:56  static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
> 00:00:56              ^~~~~~~~~~~~~~~~~~~
> 00:00:56 kernel/trace/trace.c: At top level:
> 00:00:56 kernel/trace/trace.c:6864:11: error: initialization of 'bool (*)(struct pipe_inode_info *, struct pipe_buffer *)' {aka '_Bool (*)(struct pipe_inode_info *, struct pipe_buffer *)'} from incompatible pointer type 'void (*)(struct pipe_inode_info *, struct pipe_buffer *)' [-Werror=incompatible-pointer-types]
> 00:00:56   .get   = buffer_pipe_buf_get,
> 00:00:56            ^~~~~~~~~~~~~~~~~~~
> 00:00:56 kernel/trace/trace.c:6864:11: note: (near initialization for 'buffer_pipe_buf_ops.get')
> 00:00:56 cc1: some warnings being treated as errors
> 00:00:56   ASN.1   crypto/rsapubkey.asn1.c
> 00:00:56   ASN.1   crypto/rsaprivkey.asn1.c
> 00:00:56   CC      crypto/rsa.o
> 00:00:56   CC      kernel/time/posix-cpu-timers.o
> 00:00:56 make[4]: *** [scripts/Makefile.build:276: kernel/trace/trace.o] Error 1
> 00:00:56 make[4]: *** Waiting for unfinished jobs....

The original email sent from our system has the full build logs attached.

- --
Major Hayden
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG/mSZJWWADNpjCUrc3BR4MEBH7EFAlzK5O8ACgkQc3BR4MEB
H7GACg/9GGaFLXixF7zLbKXniEjN79Vp2A9Zh+DU2rNjiHrm/5zhFbc51cKoJHPl
ugXOjTae5NRZn7yL5WwLmkWxoJtB3SBAnTlxqls9tgBEErMh2HgOjoN506V0hrmd
GDy9GJIPp3mxCFPEgDYgDQ3NwalRbCRup1nJ5BZaix9+PTxJ7+dF1Zv8e6ZZj9ff
vgia6bSoSC2PeLGzjXHlFcnzprJFFOVD7YOpAwlJIVRCfbo9aHpyyxPznyCnQ2Sh
5jBHmIhhwhuSb9n6utPhXuN1ynyI77NOvCLFa2d7zWrUHRRxaST8eDOg4D4xWg2I
Bx79q0LKg6atIg9j2JJadvYJ5171xdY6CGOo7IYh7xzktwlwvFHgWgBaal37SDu0
dBflf8mcpLUliVpGIOpP+/ngK9Bh9g1puoL3kLLLAKyFJgOOVDAOnpu61vmiTFZE
I54uHCpy4mFWIXga3pW1jBny+UBzb7ka7kZlL5JPT3R5+KK9h7Mx6hRltxQ2pBIT
cUM96xFPn/nUBGlrdT9Fjn/VFjZBz4rV6KUgDjfeMScfxgJWYbaLvPxRLXWYHUm+
HzZ1uOL4gQ9oGhkvQU/z8NAkZTEj93XVxgQYGOssY3NcCOA2OwFESvsvO7KWe+nQ
xLSM9CFxasaMqCH+wxhZWhpQNgcFdouZ8tDwZqawosddHf/IM2M=
=qzOa
-----END PGP SIGNATURE-----
