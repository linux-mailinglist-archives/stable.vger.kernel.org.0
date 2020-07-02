Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE67E2119C8
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGBBpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:45:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48192 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGBBpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 21:45:21 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200702014519epoutp04dca0d4a2b75ca34c7f12fe45bed930c8~dzCjudLTO2529525295epoutp04Y
        for <stable@vger.kernel.org>; Thu,  2 Jul 2020 01:45:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200702014519epoutp04dca0d4a2b75ca34c7f12fe45bed930c8~dzCjudLTO2529525295epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593654319;
        bh=PjPafx41GNVfaeK7QN9ako8OUQWiq47e2huHdgUGBiw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=o3xzQqUDtwfA2L4oFZJ+OihaDfi+n8hBNp32MCamlnex4GLXGmpo0pdzGx35M7OG9
         iLRm1ITfBpjcBYam+f70DsKA6MduvwnNfUj8wsoc3YrLiNN/IYCCzDgg6cm2dl76K9
         a46mQjfmoH8zvuU7mr1km1mp/TfsPxe9SR4yTEvs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200702014518epcas1p3cde2daea149096fc676c219a49922dc5~dzCjUtGZ92617826178epcas1p3g;
        Thu,  2 Jul 2020 01:45:18 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.166]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49y1BP50ymzMqYkq; Thu,  2 Jul
        2020 01:45:17 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.5E.28581.C2C3DFE5; Thu,  2 Jul 2020 10:45:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200702014516epcas1p22f130072d6872cdf0607cdbb36c9201f~dzChMfIri0631606316epcas1p22;
        Thu,  2 Jul 2020 01:45:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702014516epsmtrp21741270637ecd86125eb118bc1b1e942~dzChLl3Dd2872028720epsmtrp2b;
        Thu,  2 Jul 2020 01:45:16 +0000 (GMT)
X-AuditID: b6c32a38-2cdff70000006fa5-44-5efd3c2cfb6f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.5D.08303.C2C3DFE5; Thu,  2 Jul 2020 10:45:16 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200702014516epsmtip286858a9898b7bf6c80d0349c56bb6659~dzChCaWuW0339103391epsmtip2k;
        Thu,  2 Jul 2020 01:45:16 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Sasha Levin'" <sashal@kernel.org>
Cc:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200702013824.GH2687961@sasha-vm>
Subject: RE: [PATCH 5.7.y 0/5] exfat stable patches for 5.7.y
Date:   Thu, 2 Jul 2020 10:45:16 +0900
Message-ID: <002101d65012$6f861560$4e924020$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHpU7TLZu4sPgwmGsLVIX6Hklol4AD9uaezAhVcfvmotON5IA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmnq6Ozd84g+Mt1hbNi9ezWVzeNYfN
        YtOaa2wWCzY+YnRg8di0qpPNY//cNewenzfJBTBH5dhkpCampBYppOYl56dk5qXbKnkHxzvH
        m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gq
        pRak5BQYGhToFSfmFpfmpesl5+daGRoYGJkCVSbkZKydcoOxYClbRd//fuYGxncsXYycHBIC
        JhKvzz5k7WLk4hAS2MEocahxLhOE84lR4uSM5cwQzmdGiRuPr7F1MXKAtUxeFQYR38Uo8ePX
        Gaiil4wSZxbNYQaZyyagK/Hvz342EFtEQF1i1Y01YDazQIzE5r7NYLs5BQwklu+aDmYLC9hK
        7Fq0jRHEZhFQkXi2eQsriM0rYCnx4u5EZghbUOLkzCcsEHPkJba/hdglIaAg8fPpMlaQ40QE
        nCR6v9RClIhIzO5sA7tNQuAju8S1UxMZIepdJF4sucUEYQtLvDq+hR3ClpL4/G4v1JPVEh/3
        Q43vYJR48d0WwjaWuLl+A9gqZgFNifW79CHCihI7f89lhFjLJ/Huaw8rxBReiY42IYgSVYm+
        S4ehlkpLdLV/YJ/AqDQLyV+zkPw1C8kDsxCWLWBkWcUollpQnJueWmxYYIIc1ZsYwelQy2IH
        49y3H/QOMTJxMB5ilOBgVhLhPW3wK06INyWxsiq1KD++qDQntfgQoykwpCcyS4km5wMTcl5J
        vKGpkbGxsYWJmbmZqbGSOO9JqwtxQgLpiSWp2ampBalFMH1MHJxSDUwzj88t3L9NXbNB2s/b
        uVzprVaTyNaDwlGpd5dO+6Cu09Kw89Nh+5qdq9ecWfAh2677xy7FVcVsa+YvOv9NatdihfUm
        CXZ/QsVOdhw44sQnHBjxsOj1dOe2SWrv+f/esV4cdUp/XcnNo/WCqSky6mpcAvFvPp59zub7
        1r469J3qFo+bzvV+qXwfV0csduf78iLh+euyw/vv34k3NgiedLFyTdWd6oti3eZrDYqCfl5s
        1dmpk3FU7eiCn+KCU35G3NnMk3tnmsS+jTuqlpdZyvyVCPj8O7eJtefE/+B/D38otx+Vzjpy
        UMtY1aR13qumY8nlnxYvuf3h4Qb3y9evXf3Vs/pcsoLfPobydy9nFV+bosRSnJFoqMVcVJwI
        AOX8axwQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvK6Ozd84g/1nFSyaF69ns7i8aw6b
        xaY119gsFmx8xOjA4rFpVSebx/65a9g9Pm+SC2CO4rJJSc3JLEst0rdL4MpYO+UGY8FStoq+
        //3MDYzvWLoYOTgkBEwkJq8K62Lk4hAS2MEoceLAW+YuRk6guLTEsRNnmCFqhCUOHy6GqHnO
        KDH342Q2kBo2AV2Jf3/2g9kiAuoSq26sAbOZBeIk5vw6wQTRsJFR4vLTSywgCU4BA4nlu6aD
        2cICthK7Fm1jBLFZBFQknm3ewgpi8wpYSry4O5EZwhaUODnzCdihzAJ6Em0bGSHmy0tsfzsH
        6k4FiZ9Pl7GClIgIOEn0fqmFKBGRmN3ZxjyBUXgWkkGzEAbNQjJoFpKOBYwsqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxgqNCS2sH455VH/QOMTJxMB5ilOBgVhLhPW3wK06INyWx
        siq1KD++qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFINTKUX3XRlLtmtck5P
        k7G426JT32Yqatp04HS9ZUNDde23fyIdfyw7/RKz14s5c2st73s36Z52cFFM9MT+qreXe23k
        o3Y+LW01EzgX4pXy+f3l1w1uBWcVl3O8ka2Rmrz/kFgMl9L2nRrX/vfOPZcz01z9Q5/5XaOn
        xT2nV3OvdPg+PVDU53Wfyasf63NC7TO+tz/8rNi578HOYPUZV6VqnG2msajo3M3/+YP1VdWF
        d1yfd9w6Y/3H32xT7ycFftan1b93s58xlXtZW/VoYd2TTqmUozs+pM3ZcHTrOvFeyxm79m27
        7BoVM+Uu70PDi51mj53Fnwes0Zy7RGS6zrPiIJm6pV++7jy8d6X18vXSbUosxRmJhlrMRcWJ
        AKtyKi35AgAA
X-CMS-MailID: 20200702014516epcas1p22f130072d6872cdf0607cdbb36c9201f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac
References: <CGME20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac@epcas1p3.samsung.com>
        <20200701232024.2083-1-namjae.jeon@samsung.com>
        <20200702013824.GH2687961@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi Namjae,
Hi Sasha,
> 
> On Thu, Jul 02, 2020 at 08:20:19AM +0900, Namjae Jeon wrote:
> >Could you please push exfat stable patches into 5.7.y kernel tree ?
> 
> I've queued them up, however it would be much easier if for commits that don't require any
> modification to allow backporting you would just provide the commit ids in Linus's tree rather than
> the patches themselves.
> 
> I do see that you had to modify this one:
> 
> >Sungjong Seo (1):
> >  exfat: flush dirty metadata in fsync
> 
> In which case, a header in the commit message indicating the upstream commit id would be appriciated.
> Something like this:
Okay, I'll do that next time!
Thank you!
> 
> [ Upstream commit 5267456e953fd8c5abd8e278b1cc6a9f9027ac0a ]
> 
> Thank you!
> 
> --
> Thanks,
> Sasha

