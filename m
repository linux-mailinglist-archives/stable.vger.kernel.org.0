Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E37CFDB0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfJHPcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:32:45 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:7525
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbfJHPcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 11:32:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkr9GLDfo+q0lVB+9+4UzeVPwd0bK7vDfqPFCIOcK4ZsJbzAPjltIejhuT8bTlZ9zFnMLGAc3KwKSrtweEx6X2x68sCNV1dMeJIOB/4/qvhvvANr41/zcndOLm2NfxzWs2Z3yW9ULDieSP2Qe+ubOwUJyvTKzef3gWloMY2s9IXyO1q9VL2ePKo+H59Ondw47fy+aTX0DqMxmjmjG5ncMWlWK+WopUPYkHBIRxaQV7OMhdf5YdlPRVf4s0yoOXEDhji56r3NGk7nAAHkUuaAVZNe4WOFLtKhNeBEWqP0mtAwTcq0FVDzfYo7WVo040m+n8vGHoaioa70HW4j1OChag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0miCwdPGvMF5mYbWg5M7lVA6dV7MTKJ121IoW/A0gE=;
 b=YArFim8W6sUrWZW0p4xUZw7bZnUwgp+LaNEf4SP8NTYDW3x66q0jVQRADehC/DnX7jkdh830DeAs4okpbsA68yu4HbWvmeRTYvvFN/Va/A84N6wSJCgnOPeXHPFw7vcQgpNzZ3PL6hybre2vQGekmdb6vGuxI/asBoR8LO41vOPPT4EbISyH2zzbqSyN4BErl/3PGHPA0S0kbbmDimQcmRQVNvCxzKJPha7TkoVFOgpkqRFEZ5s1GkrqOXRBwK/EZzI4ATpDO6sADGUX/o9SJa7oWOgU2OfCwWOUJOrNEsAMReqLJiXFTCfChHwP7Wye/ZXhuCwy88BeB+aHzTN+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0miCwdPGvMF5mYbWg5M7lVA6dV7MTKJ121IoW/A0gE=;
 b=Ee2v4LhGRB8hpB7Kud8V6iv9gx8AQ9OwegsBy5OTd1ok/9ZutI0Kt1TjVaElAhalrM6g/V169MWn0m7JN/hicobiiSuSj4yPLD43N/6Eso07zlPdP0qQCrt9JZiF0qjyflrGzupyDLdBhVOuIiJSE8e5t/V19mGHnUPUJWUPlEQ=
Received: from DM6PR12MB4236.namprd12.prod.outlook.com (10.141.184.142) by
 DM6PR12MB3769.namprd12.prod.outlook.com (10.255.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Tue, 8 Oct 2019 15:32:41 +0000
Received: from DM6PR12MB4236.namprd12.prod.outlook.com
 ([fe80::f85b:e64c:1a31:8e95]) by DM6PR12MB4236.namprd12.prod.outlook.com
 ([fe80::f85b:e64c:1a31:8e95%2]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 15:32:41 +0000
From:   "Lakha, Bhawanpreet" <Bhawanpreet.Lakha@amd.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Liu, Charlene" <Charlene.Liu@amd.com>,
        "Laktyushkin, Dmytro" <Dmytro.Laktyushkin@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Subject: Re: [PATCH 4.19 033/106] drm/amd/display: support spdif
Thread-Topic: [PATCH 4.19 033/106] drm/amd/display: support spdif
Thread-Index: AQHVfGuY7FlABRemAkCj7RIBXa6kUqdQwkWAgAAgHgA=
Date:   Tue, 8 Oct 2019 15:32:41 +0000
Message-ID: <069c2621-2f63-7859-4ac7-2e8c30cc7292@amd.com>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171140.114447492@linuxfoundation.org> <20191008133741.GG608@amd>
In-Reply-To: <20191008133741.GG608@amd>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YT1PR01CA0024.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::37)
 To DM6PR12MB4236.namprd12.prod.outlook.com (2603:10b6:5:212::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Bhawanpreet.Lakha@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.55.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30d0cbac-e93b-4e3b-a655-08d74c04c1e0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR12MB3769:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB376924B62720AA09C900F5DCF99A0@DM6PR12MB3769.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:361;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(54534003)(199004)(189003)(31686004)(76176011)(5660300002)(478600001)(52116002)(81166006)(25786009)(99286004)(14454004)(81156014)(8676002)(8936002)(110136005)(7736002)(54906003)(316002)(305945005)(66446008)(64756008)(66476007)(66946007)(6512007)(71190400001)(71200400001)(476003)(66556008)(486006)(446003)(11346002)(66066001)(2616005)(31696002)(256004)(6436002)(229853002)(86362001)(6486002)(102836004)(4326008)(6116002)(186003)(2906002)(36756003)(26005)(386003)(6246003)(6506007)(3846002)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3769;H:DM6PR12MB4236.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QyQ1+L+SRC9goIaA+Q2f5uY7rQWZkD90ivDrpuClwI+xOohYE09SbeMmnjGxPHNJEgnBKmuzSJa4tpwhGGLrJUhJCTv1law2QGLAdI4snCkTJH3RCFfHXYQGddBLGHTKngSwmBH3CfgE4lbi31hXipiNv783S6uYGy3YKwnKgulCNRb4mWuvmSErGVX+2xJ4v2b2ln4XR1/TeIo86xRsKfLPpD5o2jAB+EpBSzLO1EeRE4IcnfAPPfUifaqVOVJktuGTCgmX6Be9/GE0n2vHzUuWye8v/KkfZU9qKnoaZMskkHE78i7HH93ajfFwkx9IqnZLZa1FxPvQX0zEArGDblQVN40mgQVvtewwfJyY9XrSxvK3svfhDijctxgxXwpPVVkauPkGnME2sWDj7zGOvOfyIZCY6VGEvgW0W/NyRlA=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0D66D7E1AE806049BECA73F2091B1509@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d0cbac-e93b-4e3b-a655-08d74c04c1e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 15:32:41.4851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeHzKa087la5PIpK7qYnInsDJti0ZG5IKiSOAtZd8+G75BJKfefGNg35DmkYlsbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3769
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Harry

You're completely right. This was part of a larger patch dealing with=20
embargoed code and is meaningless without the embargoed code. It=20
should've been caught and never gone upstream. We've already put some=20
new processes in place to deal with patches like this going forward.

This isn't a good candidate for stable trees but shouldn't really hurt=20
anything if it's already in.

On 2019-10-08 9:37 a.m., Pavel Machek wrote:
> Hi!
>
>> [ Upstream commit b5a41620bb88efb9fb31a4fa5e652e3d5bead7d4 ]
>>
>> [Description]
>> port spdif fix to staging:
>>   spdif hardwired to afmt inst 1.
>>   spdif func pointer
>>   spdif resource allocation (reserve last audio endpoint for spdif only)
> I'm sorry, but I don't understand this changelog. Code below modifies
> whitespace, adds a debug output, and uses local variable for
> pool->audio_count.
>
> Does not seem to be a bugfix, and does not seem to do anything with
> staging.
>
> Best regards,
> 								Pavel
>
>
>> +++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
>> @@ -229,12 +229,10 @@ bool resource_construct(
>>   				DC_ERR("DC: failed to create audio!\n");
>>   				return false;
>>   			}
>> -
>>   			if (!aud->funcs->endpoint_valid(aud)) {
>>   				aud->funcs->destroy(&aud);
>>   				break;
>>   			}
>> -
>>   			pool->audios[i] =3D aud;
>>   			pool->audio_count++;
>>   		}
>> @@ -1703,24 +1701,25 @@ static struct audio *find_first_free_audio(
>>   		const struct resource_pool *pool,
>>   		enum engine_id id)
>>   {
>> -	int i;
>> -	for (i =3D 0; i < pool->audio_count; i++) {
>> +	int i, available_audio_count;
>> +
>> +	available_audio_count =3D pool->audio_count;
>> +
>> +	for (i =3D 0; i < available_audio_count; i++) {
>>   		if ((res_ctx->is_audio_acquired[i] =3D=3D false) && (res_ctx->is_str=
eam_enc_acquired[i] =3D=3D true)) {
>>   			/*we have enough audio endpoint, find the matching inst*/
>>   			if (id !=3D i)
>>   				continue;
>> -
>>   			return pool->audios[i];
>>   		}
>>   	}
>>  =20
>> -    /* use engine id to find free audio */
>> -	if ((id < pool->audio_count) && (res_ctx->is_audio_acquired[id] =3D=3D=
 false)) {
>> +	/* use engine id to find free audio */
>> +	if ((id < available_audio_count) && (res_ctx->is_audio_acquired[id] =
=3D=3D false)) {
>>   		return pool->audios[id];
>>   	}
>> -
>>   	/*not found the matching one, first come first serve*/
>> -	for (i =3D 0; i < pool->audio_count; i++) {
>> +	for (i =3D 0; i < available_audio_count; i++) {
>>   		if (res_ctx->is_audio_acquired[i] =3D=3D false) {
>>   			return pool->audios[i];
>>   		}
>> diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c b/drivers/gp=
u/drm/amd/display/dc/dce/dce_audio.c
>> index 7f6d724686f1a..abb559ce64085 100644
>> --- a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
>> +++ b/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
>> @@ -611,6 +611,8 @@ void dce_aud_az_configure(
>>  =20
>>   	AZ_REG_WRITE(AZALIA_F0_CODEC_PIN_CONTROL_SINK_INFO1,
>>   		value);
>> +	DC_LOG_HW_AUDIO("\n\tAUDIO:az_configure: index: %u data, 0x%x, display=
Name %s: \n",
>> +		audio->inst, value, audio_info->display_name);
>>  =20
>>   	/*
>>   	*write the port ID:
>> @@ -922,7 +924,6 @@ static const struct audio_funcs funcs =3D {
>>   	.az_configure =3D dce_aud_az_configure,
>>   	.destroy =3D dce_aud_destroy,
>>   };
>> -
>>   void dce_aud_destroy(struct audio **audio)
>>   {
>>   	struct dce_audio *aud =3D DCE_AUD(*audio);
>> @@ -953,7 +954,6 @@ struct audio *dce_audio_create(
>>   	audio->regs =3D reg;
>>   	audio->shifts =3D shifts;
>>   	audio->masks =3D masks;
>> -
>>   	return &audio->base;
>>   }
>>  =20
