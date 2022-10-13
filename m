Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964765FE29D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJMTXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 15:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJMTXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 15:23:36 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A071669A9;
        Thu, 13 Oct 2022 12:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1665689012;
        bh=wzE6+WL41aojqG9P3nv7lqG4PGNUxEuHR4CFhX0xB+w=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=kXgFcnW6got2alBDFkUJIgTvR2jU7/yRtJB8n4ETklYbcqHm2yFDLrl0Cxh7JIB3M
         9tk8L3JH3dy9h0Qz9K/2kkDM3USQAA7lYxW794sM5EgcXemfBr5Zkwdc6woR+9v/as
         tmQ4bVGyq6WLrNeDo1VoXZbTSwUI+evFfp5uefXs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.235]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MDhlV-1otkN13Pmx-00ApTs; Thu, 13
 Oct 2022 21:23:32 +0200
Message-ID: <a9680d31-4f22-1357-2b42-984adea02346@gmx.de>
Date:   Thu, 13 Oct 2022 21:23:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:wiKeYYkaOp6IcFs2wIiJVP2WfNHjJMVXQIV1QfFeb9phrhJdMSX
 P3J7b4Zu8edcUNcSFow0mVnB9FvfEYQ74CDhP474or8WofUtFXbSnTF7t8M5yi+0fCv2tYJ
 95Vq5V2DC9uikin4+sRcIFbPPvd/buCls/kC6E5Yc7B4YirFLNvOFUGOkpRSzEVApnePiSE
 9xxQ3R/kg6mOtsDqHKuLg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:67XJF55EPj4=:1dsosfF5eabFR6ANyR8ewz
 5r4RdFs+k08y0VKZHCC3HBvOxL2MFivYt4Nxww37z73rAY6K3ndEdokP8Am4tSWW60GmkDZpy
 Rvv9JlzRLPB+Az3eB4XnLVO1ww6+sKrR959utvL+Y7ZlKPF0Z1Huen6L3AGaYsD24mRXrlzdS
 P2lV6M1+XjpX+DQZ5kY0fx7qBP4Xr3d8a/Xfk/o696+T/5ASnoDOqlXOF3V3EVqTJG0S/PdEn
 h4TijM54sUI2SvDi9yIi/gg5S/CVniZy/PNvg1hqh76EsQFPjgydx3zjbv034lu8wED6eDed2
 b1viE/QmhdPchvCrKeODxkCLY3x6crdK32MjbEewLBBdJXXCtKJM8XGbp69gQzALbOhzFAjIy
 IY9NO6Iss8x/iS7cdQlj7G+NOwferSUeWruamHAzxSRFobmxzkPJEwY5knMfcUftgA+3N2hpd
 qCE38ITh5Mvo1WCzWXrcGWgBJAE8FQhgIreYJQZ1MdiKkUSZSrpufOModnwIaYVnGcXbPg8IH
 Dy+Zv+yaR1lFf85u0xgighwJ4XIkxI3pTEFd41lU/3fGZnGcWshbMawhxrLkc2ldluL6nJVCA
 nwzvpORlF95Eip0J4vPjNnfr32IJrZB8bwcvDbNb5AVEAH/RiTWBhLJTwB+jdwNrSRvf171Q9
 efwHsy5ssRQMJYZEkRDTIfPF4z08GVEAysaX9x3MRl0u/Jypf82zQ6Wz1BL2D1jRZz4Pr8dfU
 TV+IosyZxOsE/INeyMVLqFzWxSOnmVFjb28TY7IKNB5x0/CAai8sJhJjqhp8KCgVAs4eqQZ0n
 ciIq1zaNop9zoUhg1gsorChgLVdRlf6bATVQTnLfR0FwMWYIM1wHFuumUCcBvnOhszO2OzpYd
 5tF30q2V9TbajStlyg274hOx4XsveKgvQwD9nn+7atsKPywZIDXAEMO/s2oKNH9nB9Zb6j5mW
 nUhkT1Kn88yGANjUXJPFm6Y5fkijYEBgUvSMtfH8K0JqrsLwJ0c4/CWoUcaCswglpgskMMAoA
 nDY8pPPXJHFzhHN67Q2kofSe/OANZzFPOovcXnZy5frAYQO/Du+cYDfypisvxltx8SOlblo3s
 LOPiMX7yK0ErTKhfZ+fispNrItEGyUXJ6muNfgCjZSIcW53TqPz5bgfCS0q6fs30r8Mfu3D5t
 wlwRjKsGq7KpMgEiXe4Ivea947HkGcvn8qFbMSZ50ZpucInv8dRLPK4mm5Q2y/sRGdllTjS3S
 mGcH6IKg1h1CFXRbwPYYO9WLS2OpJCMomo1XMDH2gyv43pEv0LQ3O8y18ptN2bvu0zrPa0k/+
 BC6P4DHJUGK3Go7z8u9ysTtb6EDkXTRfqP+8xOdnY5fcMi4CCX9GY0dCTY1GhQ956ogBjV3FU
 LRecxD31e4iWBQ6qSstEK6qM8rncTrxZXo8VW6OOEreYWyIa6W6EcMFRQws/IE0P6bpWg7Fb4
 CD1bjMbTf5fHzo43ZsM/dsLmlthx6Z+TwUfD2PsyUh0OEwo3ih5NnJ2K7KuYXsp7BkfK+ORot
 OyS4lC8zL8hRkcN/xxFuhZSwGa83BiSCnXE+FvI+jeJ0w
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.2-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

