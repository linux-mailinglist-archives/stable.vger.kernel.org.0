Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAEF17A9DE
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCEQAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:00:45 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:35928 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgCEQAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:00:44 -0500
Received: by mail-wm1-f43.google.com with SMTP id g83so6320708wme.1
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 08:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6xfq0K8177xsWCl9plOt1tnwCuIMEmEs58dKB27aHKg=;
        b=uD0gYUNPENn7OaGoVIXF7QfozzuTuR4fDzYMTam0oqh4zYsXPWzwOTC2zxsEB8lf/D
         /pU55PeEhiSTte+epQCbXA0NebrZ9VhyagMdtWK/THEdIhrsGtg0Vikp8iOEzlES0RaJ
         UctyZQbMKpSY+dR37D1rLyGIPyRI6oisH1SUyR7IGseUnxUAn31fao8RDNkDnE1RIy9C
         WPKayaDE05aHmuEcidjjy6rqO3vfGMsxAN1qRdyX7VOTppwarbtvCVlF5yFujGnfiwA8
         +5Mfik7QHss4osply/cQaEQEvaFT5OtI5mBSFpq5k1r2i3ChyfxVlo8GPzq5Iu6QXbVO
         crCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6xfq0K8177xsWCl9plOt1tnwCuIMEmEs58dKB27aHKg=;
        b=U3XfuBb1+POSLyxTY4M01Ub2ZWBJKeqXSXup/OCIu6cpujjLhx8Iho+qC4q5EtIHnx
         DuYtsteUwjf3pcrZ5UzpoZd6hnHaxXl2yvAJVJ7vPkQydOae6oOeIQvoIWFr4vcFykp7
         UmGww53m/PABFdwS45NVBKLTrXTmhZef8wYPEeLkg3BFewQZkURV/AcsoEzNNq5upL/N
         eFd8rjkoTp0dnzpGjivreqvXXh7UNwQgPXdq7A6/MqZixbc6Qi+9p8OkySKSloNoyhfL
         ejICTPxnz/nfv5XBjVtPi4Qz6Z7wxujvkftQWZRn3KVJsAM7qPNNfOWq94pWh50Ny4/2
         EQdQ==
X-Gm-Message-State: ANhLgQ2UO0O1AI8GuxTpRTRPnfxcFvKyufJhy1sp2rhMNu+O9rf8+qN2
        MOPyW/QkD+kWQ/VcfgTK2vrevA==
X-Google-Smtp-Source: ADFU+vvfr6/n9eYShC2B2BJoJWUnNL1wZWFYR8CQNGLLHyu2CmV1Zowvs3BeRliZAL7U9VRtHDJmoA==
X-Received: by 2002:a7b:cb10:: with SMTP id u16mr9708384wmj.96.1583424043308;
        Thu, 05 Mar 2020 08:00:43 -0800 (PST)
Received: from [192.168.0.104] (84-33-64-1.dyn.eolo.it. [84.33.64.1])
        by smtp.gmail.com with ESMTPSA id n13sm9743493wmd.21.2020.03.05.08.00.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:00:42 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: block, bfq: port of a series of fix commits to 5.4 and 5.5
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <e1c874e8-3cc8-7827-447f-b197e7192755@mageia.org>
Date:   Thu, 5 Mar 2020 17:00:52 +0100
Cc:     stable@vger.kernel.org, Chris Evich <cevich@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4BB9B11C-C4EF-482C-9DDD-DF8A9B71CD2A@linaro.org>
References: <543B99A1-B872-4F06-9A0F-EFFB9CAD5E14@linaro.org>
 <e1c874e8-3cc8-7827-447f-b197e7192755@mageia.org>
To:     Thomas Backlund <tmb@mageia.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Il giorno 5 mar 2020, alle ore 13:35, Thomas Backlund <tmb@mageia.org> =
ha scritto:
>=20
> Den 05-03-2020 kl. 08:49, skrev Paolo Valente:
>> Hi,
>> Fedora requested the following fix commits, currently available in
>> 5.6-rc4, to be ported to 5.4 and 5.5 [1]:
>> db37a34c563b block, bfq: get a ref to a group when adding it to a =
service tree
>> 4d8340d0d4d9 block, bfq: remove ifdefs from around gets/puts of bfq =
groups
>> 33a16a980468 block, bfq: extend incomplete name of field on_st
>> ecedd3d7e199 block, bfq: get extra ref to prevent a queue from being =
freed during a group move
>> 32c59e3a9a5a block, bfq: do not insert oom queue into position tree
>> f718b093277d block, bfq: do not plug I/O for bfq_queues with no proc =
refs
>> No change is needed for these commits to apply cleanly in 5.4 and =
5.5.
>=20
> The last one is already in 5.5.6.
>=20

Ok, thanks.

Chris,
is 5.5.6 fine for RedHat?

THanks,
Paolo

> --
> Thomas

