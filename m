Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400822BC44E
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 07:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKVG4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 01:56:30 -0500
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:43617
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbgKVG43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 01:56:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWEzxAD8b+B8tTEn14QGZn018J8ILqIBpaNyiwQugJW6Iu+uDTp5SnURUuhjaCwDoa1/SYpZeHi2zFR3/f/ylH+b+igYx8t5o/Ley5D9QcNWhtqGl2/fT2Li06eBml53vveG9SpCi6l9e2aijRk3f652OzTSy7NbYRNzpqe26dekb2MV/GFRxMvvOyhjVRs8uXeY77RRq/IK4BbI3vs31PN8AZghPzciBjgv+JHojXioesL5DiRcizjUExy7VilboBOtmfGftNRBDMVEj6h5g0RDNkYGzUT1qt3K+3sKHJhryi1DqXDLNursFlQD/w9oVruM++XwWGXHFEJlqVsovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC/Y0K4LX/WrFoYmkkiz3RKVmPGyDuD0aq6UTE5OSv8=;
 b=IsoFPnmLaOrT27rpfqXqi1UVWBou8yc7GF8f+AdvqA+CkDivsuTbSTfdbRQeZaU1h9fcMf1xctfWlTcrs3DhyjF4xFNoufUIhmZMFoXikoL55kZ1NNXfjcsj1GyXo0Fv7sOhnEajhwWkg7tSp1c7WTRDOrFqqMgdSt5all3SPc1aNDMbQK3YTigoNcr48u7YdmPABcfSLFrX1plVzUNiMKDUYIwy+F96bu4eujxDB25YA7RGCKyciB+QnIofJsg3MKFVr+EHPSV+Qj0zdNc50QrTMJcAzf2fcbwHpdloRIBX2jBvNa7FdvaTvp2zwxPs5oZWox1yD5cqOYlNaKTBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC/Y0K4LX/WrFoYmkkiz3RKVmPGyDuD0aq6UTE5OSv8=;
 b=EwFq0zRQZKeM3ZqGT+VBkkHT+9TMOcGMqofjC86jH4am7VbC2K4HVByoALuIEyxAlC4sv3JWBBE90xj3SIOedXbuY1/6nhk1Mg8iZQWFmXxDD/LwewsXWuuGxLWYmJFH/fE8dgY0WqIQRq2W07XL4509Wvs4KGRT/Zgn6cSHQmw=
Received: from DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Sun, 22 Nov
 2020 06:56:24 +0000
Received: from DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3]) by DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3%4]) with mapi id 15.20.3589.030; Sun, 22 Nov 2020
 06:56:24 +0000
From:   "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Guenter Roeck <linux@roeck-us.net>
CC:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Thread-Topic: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Thread-Index: AQHWuRhfPkP7JZ+0TkWLTfmjzaPqdanEvyEAgAFY1QCADa3pgA==
Date:   Sun, 22 Nov 2020 06:56:24 +0000
Message-ID: <DM6PR12MB438866557FEE8F42C0F6AF26E8FD0@DM6PR12MB4388.namprd12.prod.outlook.com>
References: <20201112172159.8781-1-nchatrad@amd.com>
 <238e3cf7-582f-a265-5300-9b44948107b0@roeck-us.net>
 <20201113135834.GA354992@eldamar.lan>
In-Reply-To: <20201113135834.GA354992@eldamar.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Enabled=true;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SetDate=2020-11-22T06:56:14Z;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Method=Privileged;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Name=Internal Use Only -
 Restricted;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ActionId=1d94b8d8-d4b1-4b6b-acc4-0000f3f67a91;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2020-11-22T06:55:59Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: 6462281d-fe8f-412c-b0c8-00007a97ff3f
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_enabled: true
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_setdate: 2020-11-22T06:56:21Z
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_method: Privileged
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_name: Internal Use Only -
 Restricted
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_actionid: f9d63400-2dbf-4440-91f2-0000fdb889db
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_contentbits: 0
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.159.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f940560b-bb43-4a15-233f-08d88eb3ba0d
x-ms-traffictypediagnostic: DM6PR12MB3513:
x-microsoft-antispam-prvs: <DM6PR12MB351327EDFF4F4298D360C442E8FD0@DM6PR12MB3513.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jJgi/29gqtWXzIQr4Xmp5ZnYtx7iXUhqntUvzAGYvYT7APvzqE9OjXdAGO6OfU3egHC9Co83CVogZ5GftsIQPnCyuvpvgpJKMRFoR4jIv5UoW+MHr/bvMa3bjvFM5/fxTnX0hpUZlwW+0sFSSRobMG5cvp+2i85I7UWEgYq3FoKZoDePb0VZYFIpSu05kVYD9VSwGvx2PZZ+Cy1k4da8pQVKAgK2eitE/DERINir9iRPTf6JijSDoqhIq1V/mnBlVJVe6DHVFfMCSSLL6dnrnDVqEn34h5mC2Z/wd2VqGsQS3pvLIs31IZ53Jy9M/kzl11GFRlGN1BSl2eooIW2uRY6+CHnxriVfEeahH3tIbSZrB2I4vP8BnB1dd9u+01qsfmTGTdkdnxlZWOGqm+2kWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4388.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(478600001)(26005)(4326008)(83380400001)(9686003)(7696005)(86362001)(186003)(54906003)(52536014)(8936002)(6506007)(53546011)(71200400001)(45080400002)(316002)(966005)(8676002)(33656002)(66556008)(2906002)(66946007)(76116006)(5660300002)(110136005)(66476007)(64756008)(55016002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eIABIT/4AJ7ZGu6oTvK1bIW8qVdm4GwBUuTeM5DSBkhbBb3sjjbuSP+aRaLXf+oHmMTTniIbk6Tr2UjOkl7sICmZVFXQbAF0JIFfAX6rBdxxPS6zlg0nJS3GZtcIMsO+jRcVVcUjRipchUiRQgFWuwBJMPyOjw8tZZ2x7ZqCvaD5pv3JgckfEHbTcCGRMW3fyur9H7caTsf+wlroowLz0Cot0mfI4YMTmILZcE+F5Qk1C7R2OyzEa8G5DLe8T1Nf/x8T7beXY36XW7k/0u2TfGDuoTaYnROyQBR74OdmiOsf2FmFAJKANw1tNMjIJvo7+LSEQ0uYepOu13FThGXvXeRlSt/e38hawQMk6qblE23iMH9iYNO4pz1XXImTGLBVXlUNtiNAuS4QyxtT/10cuvWtJjex6vrVQXl4Zz7Z60wGYdlTweCXffcMlqapfGlwRnUeGKG4euLbKynDLEt87opUKhh7G4y3uBEAVYqWeKflRRL5J+EMaMwPxfbgUPlSW4bSUoETG98UhoqyGQh8v4JQO7ST0TkPpFVs6W4zQAp7qquuZQOjINbih8HnTUpSTYTF4e4+ZLsPIiCpAuqqAbGuz2sKKydYNFB2OTRtgj2ENxJ5PQH1IGbUHNEP83acB+GH/BLYXBGL9NNtXt5S3w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4388.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f940560b-bb43-4a15-233f-08d88eb3ba0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2020 06:56:24.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xj4rmiqM2AZlyEFZcJEbAfw0k+Qq+UHv3/RV9dAvyJ6Z/JshvxU9YFlDUuUbllIAPxCMMmy5vOQziP3OyhuqWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Approved for External Use]

Hi Guenter, Salvatore

> This is very unusual, and may mess up the "sensors" command.
> What problem is this trying to solve ?
Guenter, sorry for the delayed response.
This fix is required to address the possible side channel attack reported i=
n CVE-2020-12912.

>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz=
illa.redhat.com%2Fshow_bug.cgi%3Fid%3D1897402&amp;data=3D04%7C01%7CNaveenKr=
ishna.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C3dd8961fe488=
4e608e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CTWFpbGZsb3d8e=
yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&am=
p;sdata=3DRCD5UPLJwh4NkUWf2Uq2r0PTYUC0f6DFDWLAQsrRJZI%3D&amp;reserved=3D0
>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsupp=
ort.lenovo.com%2Flu%2Fuk%2Fproduct_security%2FLEN-50481&amp;data=3D04%7C01%=
7CNaveenKrishna.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C3d=
d8961fe4884e608e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CTWF=
pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D=
%7C2000&amp;sdata=3DqBqjid0icKwjI%2Bz38twQqLUYwDzTfvCTF%2Bxzu0dXivY%3D&amp;=
reserved=3D0
>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fcve.=
mitre.org%2Fcgi-bin%2Fcvename.cgi%3Fname%3DCVE-2020-12912&amp;data=3D04%7C0=
1%7CNaveenKrishna.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C=
3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CT=
WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%=
3D%7C2000&amp;sdata=3DxftV%2FNo3SvC3sHVKzq74m%2B4OmlYXKjSnSHjebcL%2FGQQ%3D&=
amp;reserved=3D0

>> ?
Yes, Salvatore, thanks for bringing the links.=20

Regards,
Naveenk

-----Original Message-----
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> On Behalf Of Sa=
lvatore Bonaccorso
Sent: Friday, November 13, 2020 7:29 PM
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chatradhi, Naveen Krishna <NaveenKrishna.Chatradhi@amd.com>; linux-hwmo=
n@vger.kernel.org; naveenkrishna.ch@gmail.com; stable@vger.kernel.org
Subject: Re: [PATCH] hwmon: amd_energy: modify the visibility of the counte=
rs

[CAUTION: External Email]

Hi,

On Thu, Nov 12, 2020 at 09:24:22AM -0800, Guenter Roeck wrote:
> On 11/12/20 9:21 AM, Naveen Krishna Chatradhi wrote:
> > This patch limits the visibility to owner and groups only for the=20
> > energy counters exposed through the hwmon based amd_energy driver.
> >
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
>
> This is very unusual, and may mess up the "sensors" command.
> What problem is this trying to solve ?

Is this related to

https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugzill=
a.redhat.com%2Fshow_bug.cgi%3Fid%3D1897402&amp;data=3D04%7C01%7CNaveenKrish=
na.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C3dd8961fe4884e6=
08e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CTWFpbGZsb3d8eyJW=
IjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;s=
data=3DRCD5UPLJwh4NkUWf2Uq2r0PTYUC0f6DFDWLAQsrRJZI%3D&amp;reserved=3D0
https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsupport=
.lenovo.com%2Flu%2Fuk%2Fproduct_security%2FLEN-50481&amp;data=3D04%7C01%7CN=
aveenKrishna.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C3dd89=
61fe4884e608e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CTWFpbG=
Zsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C=
2000&amp;sdata=3DqBqjid0icKwjI%2Bz38twQqLUYwDzTfvCTF%2Bxzu0dXivY%3D&amp;res=
erved=3D0
https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fcve.mit=
re.org%2Fcgi-bin%2Fcvename.cgi%3Fname%3DCVE-2020-12912&amp;data=3D04%7C01%7=
CNaveenKrishna.Chatradhi%40amd.com%7C7672335ee2904d59fb5008d887dc381b%7C3dd=
8961fe4884e608e11a82d994e183d%7C0%7C0%7C637408727764403328%7CUnknown%7CTWFp=
bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%=
7C2000&amp;sdata=3DxftV%2FNo3SvC3sHVKzq74m%2B4OmlYXKjSnSHjebcL%2FGQQ%3D&amp=
;reserved=3D0

?

Regards,
Salvatore
