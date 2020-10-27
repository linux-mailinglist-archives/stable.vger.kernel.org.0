Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE55229C5F9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1825574AbgJ0SLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:11:32 -0400
Received: from mout.gmx.net ([212.227.17.22]:36399 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370875AbgJ0SJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 14:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1603822192;
        bh=zA8b8iEZnR62pVkknxiYTwugku/0pg36V3tGvfFDfdc=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=LbIu/ppO3O04hDG1p54UDX4KvdBmEjDu1J5dVCgAcup7kNmkl+0PBzXlOW2OfufSv
         tzGT9d5KSZJODH74A2LoENoxX/GNTFoE0n42tTbis57Cy6B7T+pzyu3fpakczH+lFx
         tYC97YRwG+ewR+q3MVT8YIdvjNkvTDV+feNiR3zY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.1.253]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MRCKC-1klj0e2xd6-00N811; Tue, 27
 Oct 2020 19:09:52 +0100
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Message-ID: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
Date:   Tue, 27 Oct 2020 19:09:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I9xvZjsrjTMp4jQljnYKxrka7wvg/oc9aUbKQDl+4fBQlrbCrWn
 gdVpVVhsEPWdXYovuDBxW7m2vB0tTRAC5z231A1qJJjU5nxUkXSzFkm4PgDybz39czhP5ni
 hFdftBEBiUE94l5fDMNFEcMKxJ3IBGEBATxk0FQrsoxR18UKqmdGpvR+42wwgWTr8NmviJm
 wIZegE1MDlBdDTU5EHCEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8rdK7K7AsPo=:jyi1NZdthEvfGxD9qEk7VQ
 K0/2UIwZcXt+OTKat3mpfHK33gUk+r3RLcqFTI1i7AtL/1i9kzmROrId0+Ii9KkvFUQTn9h7b
 ixls8OutXm82UBRQCsd5IpK3vqXrqu+/Zgnx6OuVA2CcWnvOc74HuUh1z2FtwIsg8ne7HW50r
 j+hBQT4kAv9TKeqzwVUSqnXfeKRNx/uBnANDEj5cHIpHunZ2Rh07tpQqcF6V03KARAg7j0GQh
 eni0JT9zQvneZqHxqz8hzfpsQ7fGoWlrpuc88Mcb2r99T16GQ2al2C/MvqpnBIiWNT7GBTroF
 W1wjkBvIL2GTwZRBClR2ghKuJka/hbfMbtAOTG/GEo3Zz+xe/xamA9JfPex3tv2qQBSp1AZaQ
 Qyn7jACGyFqv5LmRWCDuSO027cQx1QwvMM+SF0vFIGbP2sGPOHjZkHBuCUShGIP6svwpn0cke
 ltI8OEucN2tV8ZDRp9aXk7sPpEcV0HWXFcIUUf7k4io1U8nq5rRiGoW/Xa3QKuWVY4DXdKg2B
 A7A8WszWZjGamoisCg2OB03C991PioXelb8OkiOVc+2uN30BWZYI2XyMaZH7eMqtq3bfvBz48
 tCzJHeuqyPyJwI0YKlxykfyTbn7XHv8SAgtDpTICsgVi/HkLT6Qb6oGdTQMGIEbGbA2+eSE+e
 I5Eim0UnUxpSX/nlc/G+uAPf93m6Y0cQ+sa2mjCZ4mHQekDM4DxpwLqKFw5UWksdBGopTtksL
 sh88XB3xUY8pylXlPquUntRyRJZB4GN2FkR6og1t37yLusJvILPs2FsaF8pizB7C49TDnXmok
 maVL3d6JEhn7exYggtFGmfB1xB/uZOMV4/fE5sL1FufaCMMl5O/OuW5rAnFniR7knDRtDLnpu
 vvJcZAjT/RH6CsNmXJUA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo

this rc1 runs here (pure Intel-box) without errors.
Thanks !


An RPC (I'm thinking about since some month)
=3D=3D=3D=3D=3D=3D

Wouldn't it be better (and not so much add. work) to sort the
Pseudo-Shortlog towards subsystem/driver ?

something like this:

...
usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
usb: cdns3: gadget: free interrupt after gadget has deleted

    Lorenzo Colitti <lorenzo@google.com>
    Peter Chen <peter.chen@nxp.com>
...


Think of searching a bugfix in the shortlog.

With the current layout I need to read/"visual grep" the whole log.

With the new layout I'm able to jump to the "buggy" subsystem/driver and
only need to read that part of the log to get the info if the bug is
fixed or not yet


Well, surely there are other ways to get the info I need, e.g.
search-function of my favorite browser, but ...

=2D-
regards

Ronald
