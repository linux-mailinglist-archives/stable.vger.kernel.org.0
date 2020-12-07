Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148602D178E
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 18:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgLGR20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 12:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLGR20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 12:28:26 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3901C061749
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 09:27:45 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id b8so12893285ila.13
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 09:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gQBEcFBBxJ4otlgkOyI9s27LIC9z3FYKfvDZXAgrKI0=;
        b=CFF7XhAnUkuQDv2heC3YhgRG8V2UTqx5iohgPXOmoQMbStERx88hAqfU6vWeYmvIqM
         S9Br1b/ajhw3SSAKxNONkpNIOMaNdPFT6MoUybCrJ6PJnV39LVdrSkdhCRXjxd7UcNTK
         JJDAfAZkHd77enGu7Bn+0rnJuF15A2nNVUJ2d5Yrc6cLbL7fh6jo8RM2dbtpIti0Lfkd
         UmGcc32hhNpjb9FQ/bLOx3znOQEzTq1JwlOPhvX7CGzKSHJM3Zfk/YbJB/lp8MdQn9cF
         lsj1DHvGbiXiTKv4B9uK2FdXISekAvXBLIufGd+toWoVz3S24HHPnNoIHTSnBqolDvRe
         z/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gQBEcFBBxJ4otlgkOyI9s27LIC9z3FYKfvDZXAgrKI0=;
        b=d6BOmy42vaXRsp0MQZxtRfNV46mX4lyEJaiY0lSXlQ2tmTm3baqJrcrapcK3boL4ah
         lmPvrIIqR416kP+/FEUQ7MpYcidnjcxpG8WF9892Y/PUS4ujg6fwekO6Hzf+gbU8o164
         YM8GMTyGrOJvrukpheNmZzmi7vPaMHDqDAF6NyjTb1259TVr80qN6hgh/Rh8LgW9r5u5
         LCiEP2MfXJKG8yo8fK4BMxhsJOjE6I/UdFt7U+PGNtKcrFwfsyJQZT1V1NcuXQAETtPR
         KzklHsd9Xum8xwUSwOfEOWpGmkbit03aBDr2wUzT6MkN1IwJ/ti4Dct6CR0UJPowNkDs
         wakQ==
X-Gm-Message-State: AOAM532i5YsX5Ja8HPVjJ+OYEPprX/G8drdFAPw0kcZtZprC1rcXB+tI
        ij6zqJvpx+df/iiFS5ZcSOmFLzkh0qW9F5xW23NM0Q==
X-Google-Smtp-Source: ABdhPJzEcbOnDTs9OpE2h6dCKVbyTT2C8bcWXg3K71yvbk6E0MPma48Q8cNexbXw8OdyxixvdUZYYzuN/lr4Rg/uJMU=
X-Received: by 2002:a92:d0ca:: with SMTP id y10mr13733711ila.68.1607362064920;
 Mon, 07 Dec 2020 09:27:44 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com> <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com> <170D5DF4-443F-47F6-B645-A8762E17A475@amazon.com>
In-Reply-To: <170D5DF4-443F-47F6-B645-A8762E17A475@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 18:27:33 +0100
Message-ID: <CANn89iK_dheHnVjbtg=QkgF=Ng8dYMGfL2RR_3NRv8gwfbgaAQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 7, 2020 at 6:17 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
>     >Thanks for testing this, Eric. Would you be able to share the MTU
>     >config commands you used, and the tcpdump traces you get? I'm
>     >surprised that receive buffer autotuning would work for advmss of
>     >around 6500 or higher.
>
> Packet capture before applying the proposed patch
>
> https://tcpautotuningpcaps.s3.eu-west-1.amazonaws.com/sender-bbr-bad-unpa=
tched.pcap?X-Amz-Algorithm=3DAWS4-HMAC-SHA256&X-Amz-Credential=3DAKIAJNMP5Z=
Z3I4FAQGAQ%2F20201207%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=3D20201207=
T170123Z&X-Amz-Expires=3D604800&X-Amz-SignedHeaders=3Dhost&X-Amz-Signature=
=3Da599a0e0e6632a957e5619007ba5ce4f63c8e8535ea24470b7093fef440a8300
>
> Packet capture after applying the proposed patch
>
> https://tcpautotuningpcaps.s3.eu-west-1.amazonaws.com/sender-bbr-good-pat=
ched.pcap?X-Amz-Algorithm=3DAWS4-HMAC-SHA256&X-Amz-Credential=3DAKIAJNMP5ZZ=
3I4FAQGAQ%2F20201207%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=3D20201207T=
165831Z&X-Amz-Expires=3D604800&X-Amz-SignedHeaders=3Dhost&X-Amz-Signature=
=3Df18ec7246107590e8ac35c24322af699e4c2a73d174067c51cf6b0a06bbbca77
>
> kernel version & MTU and configuration  from my receiver & sender is atta=
ched to this e-mail, please be aware that EC2 is doing MSS clamping so you =
need to configure MTU as 1500 on the sender side if you don=E2=80=99t have =
any MSS clamping between sender & receiver.
>
> Thank you.
>
> Hazem

Please try again, with a fixed tcp_rmem[1] on receiver, taking into
account bigger memory requirement for MTU 9000

Rationale : TCP should be ready to receive 10 full frames before
autotuning takes place (these 10 MSS are typically in a single GRO
packet)

At 9000 MTU, one frame typically consumes 12KB (or 16KB on some arches/driv=
ers)

TCP uses a 50% factor rule, accounting 18000 bytes of kernel memory per MSS=
.

->

echo "4096 180000 15728640" >/proc/sys/net/ipv4/tcp_rmem



>
>
> =EF=BB=BFOn 07/12/2020, 16:34, "Neal Cardwell" <ncardwell@google.com> wro=
te:
>
>     CAUTION: This email originated from outside of the organization. Do n=
ot click links or open attachments unless you can confirm the sender and kn=
ow the content is safe.
>
>
>
>     On Mon, Dec 7, 2020 at 11:23 AM Eric Dumazet <edumazet@google.com> wr=
ote:
>     >
>     > On Mon, Dec 7, 2020 at 5:09 PM Mohamed Abuelfotoh, Hazem
>     > <abuehaze@amazon.com> wrote:
>     > >
>     > >     >Since I can not reproduce this problem with another NIC on x=
86, I
>     > >     >really wonder if this is not an issue with ENA driver on Pow=
erPC
>     > >     >perhaps ?
>     > >
>     > >
>     > > I am able to reproduce it on x86 based EC2 instances using ENA  o=
r  Xen netfront or Intel ixgbevf driver on the receiver so it's not specifi=
c to ENA, we were able to easily reproduce it between 2 VMs running in virt=
ual box on the same physical host considering the environment requirements =
I mentioned in my first e-mail.
>     > >
>     > > What's the RTT between the sender & receiver in your reproduction=
? Are you using bbr on the sender side?
>     >
>     >
>     > 100ms RTT
>     >
>     > Which exact version of linux kernel are you using ?
>
>     Thanks for testing this, Eric. Would you be able to share the MTU
>     config commands you used, and the tcpdump traces you get? I'm
>     surprised that receive buffer autotuning would work for advmss of
>     around 6500 or higher.
>
>     thanks,
>     neal
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembou=
rg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlin=
gton Road, Dublin 4, Ireland, branch registration number 908705
>
>
