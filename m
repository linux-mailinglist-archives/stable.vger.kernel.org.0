Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9E3C7A41
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 01:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhGMXpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 19:45:41 -0400
Received: from mout.gmx.net ([212.227.17.21]:49283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhGMXpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 19:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626219769;
        bh=NFK0JmTje2XquxmWeGMwh8hvNPkY78Lb2EycqbxdNg8=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=GlQ3vCfmZlYQTFIzzSt2LgxIfyRXFEoEHIouaCjs90cG45B6k/5d1e552KYZb6rkz
         q/D9O3RCZNWMGf7l8hfvCaWrEVS82zSSptpPK9tTCRJYc3EQUvBmJW3tv97IqrCZP9
         onp7rR2vp8jUJfWrLz8n/Be1L4muoHZ/ks85UGcc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.4.8]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MK3Rm-1li4sZ1QSc-00LUUl; Wed, 14
 Jul 2021 01:42:49 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <02a79df3-f7cc-53ba-e5f2-3b38007468a3@gmx.de>
Date:   Wed, 14 Jul 2021 01:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kSjeC345SE5rXz6k59BnEOxh1tYosyfrhUteuPmeH/Zwi3vlDLO
 3zrDrkqoOfisJ8vVTKH7HQwsRuYOVTBNLl7LLCcm6HdzbbchBOOQvnd7nd2AHLs1XsdGGue
 lwHL4x074uVZv33lBSgsa1gH+D1S4lLtEE9Y/Wo85st7pfXKokq+01Np2o044LJVRKFFhmf
 /yWdlTwiMLv+UkacTAl4Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FhmN599gTqs=:xuRLlMdiC5qJfHVxHlB6CK
 blMbXx3E1kPXZ7EaJiatKGRdWE9aYJoJ8mZD5RMI5oHH7aUf6798n9tbluTbxH5bfz9nD5eHf
 2aM+3CAkqLoNFS4NFDf3iVNypYTELEalNDchHx9mg4mCJskHk+ht5nT4zX0JXCG2AC1b/TUW2
 TYwXk8NuKdNcuhJQ+nvVek/vP2KtqayS0X8rLL5iSLt4YLtM3FPDuA9AHZcrubEFltUIsRiY/
 1esdVf/sWDJpiV4h70EFGkEr4dRCCPEo+6gS/jokbO1UQBGqPF/H4i8nhEvu4ebpc/7pA9PHZ
 t04nufSRPReYTBHbUbc1qNQgLaVy+1ruIAEY2nMf46dw0Ss5TcWKJOuHyqMOM3IhSJxgJJKfG
 EJkUwkJJ2VZQM9isWKv7+DeuBsbLpinkkQyEJNQWjm+4B3F9JgU8kxiu7M0bV8R1e4ge33bfu
 7oc+owwwIdMDlXrpfN2LIHuex+dVC/vwXRtFsdd4QPp+fjswGzhYp3AkYn3Xz4X7BCEmRXeVp
 u0woyV9X/dN4e3jNDSjVdnjhl4z5vr8ASBcQX+AlG8uiNjuq+dO3qgR4qz5N/Lz7zLML3gDWI
 6WGg1p37klEPoBLn4OhEewpaudC9Y7Woo3YkEcIXkMJvsM5zYFQTTjDkUjcMAUH5mgCTDQ0PI
 /zfG2Ri1lA2iQZyemO1ugvTBKU8JlhvlrYSNXAKjdds/XmEVEHVJdkatAsAn9Xtcy5Bn50KJX
 dQd1LuzXYhl2gXapCZg4Va7Ihh8oYzlzFtTSJjrdWUG8Y04K/SH05bmGf9w/TA2lypSP6gwag
 SNt3fGuKt9IZUO9boYZt8qHWs7bQ9EhSjiL9TCdj3uTNZ/v+69sHWLvdM5+Js/UEwp4iqD6+P
 gn0hHT6kez/UHRmkB+A2c0bbiGqgCy+sijzwc+juG1RnDLt8lNMTVT3l2s3WgCYF3PUQG4cbf
 1CQm48aUh4WszattanlA6AwdLNwzyfu9DGMPvH52ckkgUxzzRrN6CP6Mzz5RpdTL20+UMy3BB
 s0yV7/EBPgB/6ORMAHwlyjva++HATH9602PkLjScOyutXnLstDgSie169B2QDS6Fz9Amn5v3s
 O3hufghnNOpJJcQvyU6XLG6AQpiWwYB56OH
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo

all fine here on an Intel i7-6700 box.

thanks

=2D-
regards

Ronald
